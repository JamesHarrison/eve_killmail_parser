# EVE Killmail parser
module Eve
  module Killmail
    # Class to handle parsing of the killmail into simple classes.
    # 
    # Attributes
    # * victim (Victim) - The victim of the killmail
    # * attackers ([Attacker]) - Array of attackers
    # * dropped ([Item]) - Array of items dropped
    # * destroyed ([Item]) - Array of items destroyed
    # * items ([Item]) - Addition of the two arrays above
    # * podkill (boolean) - True if this mail has a pod victim (no destroyed/dropped items)
    class Parser
      attr_accessor :date, :victim, :attackers, :dropped, :destroyed, :podkill
      public
      def initialize(mail='')
        @date = mail.match(/((?:\d{4}).(?:\d{2})(?:.+))$/)[0]
        @victim = Eve::Killmail::Classes::Victim.new(mail)
        @attackers = []
        @destroyed = []
        @dropped = []
        @podkill = false
        unless mail.include?('Destroyed items:') or mail.include?('Dropped items:')
          @podkill = true
        end
        mail.split(/\r/).length > 1 ? mailsep = /\r\n/ : mailsep = /\n/
        mail_lines = mail.split(mailsep)
        unless @podkill
          destroyed_line = 0
          dropped_line = 0
        end
        involved_line = 0
        end_line = 0
        mail_lines.each_with_index do |line,index|
          unless @podkill
            destroyed_line = index if line.include?('Destroyed')
            dropped_line = index if line.include?('Dropped')
          end
          involved_line = index if line.include?('Involved')
          end_line = index
        end
        unless @podkill
          attackers = mail_lines[(involved_line+1)..(destroyed_line-1)]
          destroyed = mail_lines[(destroyed_line+1)..(dropped_line-1)]
          dropped = mail_lines[(dropped_line+1)..(end_line)]
        else
          attackers = mail_lines[(involved_line+1)..end_line]
        end
        
        # NOTES on splitting of mails
        # 99.9999% of mails will use \r\n as a linebreak seperator.
        attacker_block_indexes = []
        attackers.each_with_index do |ln,idx|
          if ln.size < 2 then # We're a gap between blocks!
            attacker_block_indexes.push idx+involved_line+1 # Correct offset
          end
        end
        blocksep = '\r\n'
        attacker_block_indexes.each_with_index do |abi,idx|
          b = []
          if attacker_block_indexes[idx+1]
            b = mail_lines[(abi)..(attacker_block_indexes[idx+1])]
          else
            unless @podkill
              b = mail_lines[(abi)..(destroyed_line-1)]
            else
              b = mail_lines[(abi)..(end_line)]
            end
          end
          if b.length > 2 # Check for blank lines here
            @attackers.push Eve::Killmail::Classes::Attacker.new(b.join("\n"))
          end
        end
        unless @podkill
          destroyed.each do |item|
            if item.length > 2
              @destroyed.push Eve::Killmail::Classes::Item.new(item.to_s)
            end
          end
          dropped.each do |item|
            if item.length > 2
              @dropped.push Eve::Killmail::Classes::Item.new(item.to_s)
            end
          end
        end
      end
    end
    
    module Classes
      # Class for the victim of the killmail.
      # 
      # Attributes
      # * name (String) - Name of the character
      # * security (Float) - Security Status of the character
      # * corporation (String) - Name of the character's corporation
      # * alliance (String) - Name of the charcter's alliance
      # * faction (String) - Name of the character's faction (FW- not used in normal PVP, will be 'NONE')
      # * damage_taken (Integer) - Amount of damage taken by the character
      # * destroyed (String) - Type name of the destroyed ship
      # * system (String) - Name of the system the character was destroyed in
      # * moon (String) - Name of the moon a POS was anchored at (nil if not a POS killmail)
      class Victim
        attr_accessor :name, :security, :corporation, :alliance, :faction, :damage_taken, :destroyed, :system, :moon, :object
        def initialize(block)
          @object = false
          if block.include? 'Victim: '
            @name = Eve::Killmail.line('Victim',block).gsub('Victim: ','').chomp.to_s
          else
            @name = Eve::Killmail.line('Destroyed',block).gsub('Destroyed: ','').chomp.to_s
            @object = true
          end
          @moon = Eve::Killmail.line('Moon',block).gsub('Moon: ','').chomp.to_s if block.include?'Moon:'
          @system = Eve::Killmail.line('System',block).gsub('System: ','').chomp.to_s
          @security = Eve::Killmail.line('Security',block).gsub('Security: ','').to_f
          @corporation = Eve::Killmail.line('Corp',block).gsub('Corp: ','').chomp.to_s
          @alliance = Eve::Killmail.line('Alliance',block).gsub('Alliance: ','').chomp.to_s
          if block.include?'Faction: '
            @faction = Eve::Killmail.line('Faction',block).gsub('Faction: ','').chomp.to_s
          else
            @faction = 'NONE'
          end
          @damage_taken = Eve::Killmail.line('Damage Taken',block).gsub('Damage Taken: ','').to_i
          @destroyed = Eve::Killmail.line('Destroyed',block).gsub('Destroyed: ','').chomp.to_s
        end
      end
      # Class for an attacker in the killmail.
      # 
      # Attributes
      # * name (String) - Name of the character
      # * security (Float) - Security Status of the character
      # * corporation (String) - Name of the character's corporation
      # * alliance (String) - Name of the charcter's alliance
      # * faction (String) - Name of the character's faction. Will be nil if this is not a FW killmail.
      # * damage_done (Integer) - Amount of damage given by the character
      # * ship (String) - Type name of the attacking ship
      # * final_blow (Boolean) - True if this attacker laid the final blow on the victim
      # * weapon (String) - Name of the weapon used by the attacker
      # * object (Boolean) - If this is true, then only weapon, corporation, and damage done will be set (used for POS attacking pilots)
      class Attacker
        attr_accessor :name, :security, :corporation, :alliance, :faction, :damage_done, :ship, :weapon, :final_blow, :object
        def initialize(block)
          if block.include? 'Corp: '
            @object = false
          else
            @object = true
          end
          if block.include?'(laid the final blow)'
            @final_blow = true
          else
            @final_blow = false
          end
          unless @object
            @name = Eve::Killmail.line('Name',block).gsub('Name: ','').gsub(' (laid the final blow)','').chomp.to_s
            @security = Eve::Killmail.line('Security',block).gsub('Security: ','').to_f
            @corporation = Eve::Killmail.line('Corp',block).gsub('Corp: ','').chomp.to_s
            @alliance = Eve::Killmail.line('Alliance',block).gsub('Alliance: ','').chomp.to_s
            @faction = Eve::Killmail.line('Faction',block).gsub('Faction: ','').chomp.to_s if block.include?'Faction: '
            @ship = Eve::Killmail.line('Ship',block).gsub('Ship: ','').chomp.to_s
            @weapon = Eve::Killmail.line('Weapon',block).gsub('Weapon: ','').chomp.to_s
          else
            @weapon = Eve::Killmail.line('Name',block).gsub('Name: ','').match(/(.+) \/ (.+)/)[1]
            @corporation = Eve::Killmail.line('Name',block).gsub('Name: ','').match(/(.+) \/ (.+)/)[2]
          end
          @damage_done = Eve::Killmail.line('Damage Done',block).gsub('Damage Done: ','').to_i
        end
      end
      # Class for an item in the killmail.
      # 
      # Attributes
      # * name (String) - Name of the item type
      # * quantity (Integer) - The quantity of this item
      # * cargo (Boolean) - Flag, true if the item was in the cargohold and not fitted
      # * drone (Boolean) - Flag, true if the item was in the drone bay and not fitted
      class Item
        attr_accessor :name, :quantity, :cargo, :drone
        def initialize(block)
          return nil if block.length < 3
          @cargo = false
          @drone = false
          @name = ''
          @quantity = 1
          @cargo = true if block.include?('(Cargo)')
          @drone = true if block.include?('(Drone Bay)')
          qtytmp = block.match(/(?:.*)(?:Qty: )(\d+)/)
          @quantity = qtytmp[1].to_i if qtytmp
          nmetmp = block.match(/([\w' -]+).*$/)
          @name = nmetmp[1].to_s if nmetmp
        end
      end
      
    end
    # Module for outputting a killmail in the standard format
    module Printer
      # Class for standard-format output (faction-warfare supporting killmail parsers).
      # 
      # Attributes:
      # * mail (String) - The final output
      # Expects:
      # * mail (Eve::Killmail::Parser) - The parser object of the input mail
      class Standard
        attr_reader :mail
        def initialize(mail)
          @mail = ''
          insert mail.date
          newline
          insert "Victim: #{mail.victim.name}"
          insert "Alliance: #{mail.victim.alliance}"
          insert "Faction: #{mail.victim.faction}"
          insert "Corp: #{mail.victim.corporation}"
          insert "Destroyed: #{mail.victim.destroyed}"
          insert "System: #{mail.victim.system}"
          insert "Security: #{mail.victim.security.to_s}"
          insert "Damage Taken: #{mail.victim.damage_taken.to_s}"
          newline
          insert "Involved parties:"
          newline
          mail.attackers.each do |attacker|
            insert "Name: #{attacker.name}"
            insert "Security: #{attacker.security.to_s}"
            insert "Alliance: #{attacker.alliance}"
            insert "Faction: #{attacker.faction}"
            insert "Corp: #{attacker.corporation}"
            insert "Ship: #{attacker.ship}"
            insert "Weapon: #{attacker.weapon}"
            insert "Damage Done: #{attacker.damage_done.to_s}"
            newline
          end
          newline
          insert "Destroyed items:"
          newline
          mail.destroyed.each do |item|
            insert_item item
          end
          newline
          insert "Dropped items:"
          newline
          mail.dropped.each do |item|
            insert_item item
          end
        end
        # Builds an item string and adds it to the active output.
        # Expects:
        # * item (Eve::Killmail::Classes::Item) - Item to add
        def insert_item(item)
          str = item.name
          if item.quantity > 1
            str << ", Qty: #{item.quantity.to_s}"
          end
          if item.cargo
            str << " (Cargo)"
          end
          if item.drone
            str << " (Drone Bay)"
          end
          insert str
        end
        # Adds a newline character
        def newline
          @mail = @mail + "\n"
        end
        # Inserts a new row, followed by a newline.
        # Expects:
        # * str (String) - String to add
        def insert(str)
          return if str
          return if str.length == 0
          @mail = @mail + str.chomp
          newline
        end
        # Formatting helper for debugging.
        def to_s
          @mail
        end
        # Formatting helper for debugging.
        def inspect
          @mail
        end
      end
    end
    # Module which contains classes for rewriting killmail data eg. for fixing broken mails
    module Rewriters
      # Fixer for killmails in which the faction has been put in the alliance field when not None.
      # Specially cooked for Hoggs on account of boredom.
      # 
      # Attributes:
      # * mail (Eve::Killmail::Parser) - The fixed killmail
      # Expects:
      # * killmail (String) - Raw killmail
      class FactionalWarfareAlliances
        attr_accessor :mail
        def initialize(killmail)
          @mail = Parser.new(killmail)
          factions = ['Amarr Empire', 'Minmatar Republic','Caldari State','Gallente Federation']
          if factions.include? @mail.victim.alliance
            # We need to set the faction of this mail to the alliance and the alliance to none
            @mail.victim.faction = @mail.victim.alliance
            @mail.victim.alliance = 'NONE'
          end
          @mail.attackers.each do |attacker|
            if factions.include? attacker.alliance
              # We need to set the faction of this mail to the alliance and the alliance to none
              attacker.faction = attacker.alliance
              attacker.alliance = 'NONE'
            end
          end
        end
      end
    end
    # Helper method- searches a string for a string and returns the whole line, similar to grep's default behaviour
    # 
    # Expects:
    # * string (String) - The string to search for
    # * source (String) - The string to search within
    def self.line(string, source)
      source.each_with_index do |line, line_number|
        return line if line.to_s.include? string
      end
    end
  end
end
