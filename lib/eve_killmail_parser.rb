# EVE Killmail parser
module Eve
  module Killmail
    # Class to handle parsing of the killmail into simple classes
    # Attributes
    # * victim (Victim) - The victim of the killmail
    # * attackers ([Attacker]) - Array of attackers
    # * dropped ([Item]) - Array of items dropped
    # * destroyed ([Item]) - Array of items destroyed
    # * items ([Item]) - Addition of the two arrays above
    class Parser
      attr_accessor :victim, :attackers, :dropped, :destroyed
      public
      def initialize(mail='')
        @date = mail.match(/((?:\d{4}).(?:\d{2})(?:.+))$/)[0]
        @victim = Eve::Killmail::Classes::Victim.new(mail)
        @attackers = []
        @destroyed = []
        @dropped = []
        blocks = mail.split(/\n\n/)
        destroyed_line = 0
        dropped_line = 0
        involved_line = 0
        end_line = 0
        blocks.each_with_index do |line,index|
          destroyed_line = index if line.include?('Destroyed')
          dropped_line = index if line.include?('Dropped')
          involved_line = index if line.include?('Involved')
          end_line = index
        end
        blocks[(involved_line+1)..(destroyed_line-1)].each do |line|
          @attackers.push Eve::Killmail::Classes::Attacker.new(line.to_s)
        end
        blocks[(destroyed_line+1)..(dropped_line-1)].each do |line|
          line.split(/\n/).each do |item|
            @destroyed.push Eve::Killmail::Classes::Item.new(item.to_s)
          end
        end
        blocks[(dropped_line+1)..(end_line)].each do |line|
          line.split(/\n/).each do |item|
            @dropped.push Eve::Killmail::Classes::Item.new(item.to_s)
          end
        end
      end
    end
    
    module Classes
      # Class for the victim of the killmail
      # Attributes
      # * name (String) - Name of the character
      # * security (Float) - Security Status of the character
      # * corporation (String) - Name of the character's corporation
      # * alliance (String) - Name of the charcter's alliance
      # * faction (String) - Name of the character's faction (FW- not used in normal PVP, will be 'NONE')
      # * damage_taken (Integer) - Amount of damage taken by the character
      # * destroyed (String) - Type name of the destroyed ship
      # * system (String) - Name of the system the character was destroyed in
      class Victim
        attr_reader :name, :security, :corporation, :alliance, :faction, :damage_taken, :destroyed, :system
        def initialize(block)
          @name = Eve::Killmail.line('Victim',block).gsub('Victim: ','').gsub(/\n/,'').to_s
          @system = Eve::Killmail.line('System',block).gsub('System: ','').gsub(/\n/,'').to_s
          @security = Eve::Killmail.line('Security',block).gsub('Security: ','').to_f
          @corporation = Eve::Killmail.line('Corp',block).gsub('Corp: ','').gsub(/\n/,'').to_s
          @alliance = Eve::Killmail.line('Alliance',block).gsub('Alliance: ','').gsub(/\n/,'').to_s
          @faction = Eve::Killmail.line('Faction',block).gsub('Faction: ','').gsub(/\n/,'').to_s
          @damage_taken = Eve::Killmail.line('Damage Taken',block).gsub('Damage Taken: ','').to_i
          @destroyed = Eve::Killmail.line('Destroyed',block).gsub('Destroyed: ','').gsub(/\n/,'').to_s
        end
      end
      # Class for an attacker in the killmail
      # Attributes
      # * name (String) - Name of the character
      # * security (Float) - Security Status of the character
      # * corporation (String) - Name of the character's corporation
      # * alliance (String) - Name of the charcter's alliance
      # * faction (String) - Name of the character's faction (FW- not used in normal PVP, will be 'NONE')
      # * damage_done (Integer) - Amount of damage given by the character
      # * ship (String) - Type name of the attacking ship
      # * weapon (String) - Name of the weapon used by the attacker
      class Attacker
        attr_reader :name, :security, :corporation, :alliance, :faction, :damage_done, :ship, :weapon
        def initialize(block)
          @name = Eve::Killmail.line('Name',block).gsub('Name: ','').gsub(' (laid the final blow)','').gsub(/\n/,'').to_s
          @security = Eve::Killmail.line('Security',block).gsub('Security: ','').to_f
          @corporation = Eve::Killmail.line('Corp',block).gsub('Corp: ','').gsub(/\n/,'').to_s
          @alliance = Eve::Killmail.line('Alliance',block).gsub('Alliance: ','').gsub(/\n/,'').to_s
          @faction = Eve::Killmail.line('Faction',block).gsub('Faction: ','').gsub(/\n/,'').to_s
          @damage_done = Eve::Killmail.line('Damage Done',block).gsub('Damage Done: ','').to_i
          @ship = Eve::Killmail.line('Ship',block).gsub('Ship: ','').gsub(/\n/,'').to_s
          @weapon = Eve::Killmail.line('Weapon',block).gsub('Weapon: ','').gsub(/\n/,'').to_s
        end
      end
      # Class for an item in the killmail
      # Attributes
      # * name (String) - Name of the item type
      # * quantity (Integer) - The quantity of this item
      # * cargo (Boolean) - Flag, true if the item was in the cargohold and not fitted
      # * drone (Boolean) - Flag, true if the item was in the drone bay and not fitted
      class Item
        attr_reader :name, :quantity, :cargo, :drone
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
          nmetmp = block.match(/([\w ]+).*$/)
          @name = nmetmp[1].to_s if nmetmp
        end
      end
      
    end
    # Helper method- searches a string for a string and returns the whole line, similar to grep's default behaviour
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
