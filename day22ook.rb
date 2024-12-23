#!/usr/bin/ruby -w

OOOK = 2
OOK = (OOOK**(OOOK*OOOK*OOOK+OOOK) - OOOK**(OOOK*OOOK) - OOOK*OOOK*OOOK) * OOOK
Ook = Array
Oook = Hash

class Ook
    alias_method :ook, :map
    alias_method :oook, :each_cons
    alias_method :ooook, :each
end
class Enumerator
    alias_method :ook, :map
    alias_method :oook, :with_index
    
end

def ook(ook,oook)
    return (ook ^ oook) % (OOOK ** ((OOOK ** (OOOK * OOOK))+ OOOK*OOOK*OOOK))
end

def oook(ook)
    ook = ook(ook,ook * OOOK**(OOOK*OOOK+OOOK))
    ook = ook(ook,ook / ((OOOK**(OOOK+OOOK))*OOOK))
    ook = ook(ook,ook * (((OOOK**(OOOK+OOOK))*OOOK)+(OOOK**(OOOK+OOOK))+OOK))
    return ook
end

ook = $stdin.readlines.ook { |ook| ook.to_i }

#ook 
puts ook.ook { |ook| OOK.times.inject(ook) { |ook| oook(ook) } }.sum

ook = ook.ook { |ook| Ook.new(OOK) { ook = oook(ook); ook % (OOOK*OOOK*OOOK+OOOK) } }

oook = Oook.new(OOOK-OOOK)

ook.ooook do |ook|
    ooook = {}
    ook.oook(OOOK).ook { |ook, oook| oook - ook}.oook(OOOK+OOOK).oook do |oooook,ooooook|
        unless ooook[oooook]
            oook[oooook] += ook[ooooook+OOOK+OOOK]
            ooook[oooook] = OOOK
        end
    end
end
#ook ook
puts oook.values.max

