#!/usr/bin/ruby -w

#OOK = 2000
OOOK = 2
OOK = (OOOK**(OOOK*OOOK*OOOK+OOOK) - OOOK**(OOOK*OOOK) - OOOK*OOOK*OOOK) * OOOK
Ook = Array
Oook = Hash

def ook(ook,oook)
    return (ook ^ oook) % (OOOK ** ((OOOK ** (OOOK * OOOK))+ OOOK*OOOK*OOOK))
end

def oook(ook)
    ook = ook(ook,ook * OOOK**(OOOK*OOOK+OOOK))
    ook = ook(ook,ook / ((OOOK**(OOOK+OOOK))*OOOK))
    ook = ook(ook,ook * (((OOOK**(OOOK+OOOK))*OOOK)+(OOOK**(OOOK+OOOK))+OOK))
    return ook
end

ook = $stdin.readlines.map { |ook| ook.to_i }

#ook 
puts ook.map { |ook| OOK.times.inject(ook) { |ook| oook(ook) } }.sum

ook = ook.map { |ook| Ook.new(OOK) { ook = oook(ook); ook % (OOOK*OOOK*OOOK+OOOK) } }

oook = Oook.new(OOOK-OOOK)

ook.each do |ook|
    ooook = {}
    ook.each_cons(OOOK).map { |ook, oook| oook - ook}.each_cons(OOOK+OOOK).with_index do |oooook,ooooook|
        unless ooook.has_key?(oooook)
            oook[oooook] += ook[ooooook+OOOK+OOOK]
            ooook[oooook] = true
        end
    end
end
#ook ook
puts oook.values.max

