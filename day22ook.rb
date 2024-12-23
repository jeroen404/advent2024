#!/usr/bin/ruby -w

OOOK = 2
OOK = (OOOK**(OOOK*OOOK*OOOK+OOOK) - OOOK**(OOOK*OOOK) - OOOK*OOOK*OOOK) * OOOK
OOKOOK = (OOOK ** (OOOK + OOOK + OOOK)) + (OOOK*OOOK*OOOK*OOOK*OOOK) - OOOK
Ook = Array
Oook = Hash

def ookook(ook)
    ookook = OOOK - OOOK
    oook = OOOK - OOOK
    ook.scan(/../) do |ook|
        ookook += ook == 'oo' ? OOOK-OOOK : OOOK**oook
        oook += OOOK ** (OOOK - OOOK)
    end
    return (OOKOOK + ookook).chr
end

def ookoook(ook)
    return ook.split(' ').map { |ook| ookook(ook) }.join
end
class String
    alias_method :ookook, :to_sym
end
class Ook
    alias_method :ook, ookoook("okokokok okok oookoooook").ookook
    alias_method :oook, ookoook("okokok okok okoook oookoook ok okoook okoooooook oooooooook okoookoook").ookook
    alias_method :ookook, ookoook("okokok okok okoook oookoook").ookook
    alias_method :oookook, ookoook("okoookoook okokokoook okokokok").ookook
    alias_method :oookoook, ookoook("okokokok okok oookoookok").ookook
end
class Oook
    alias_method :ook, ookoook("oooooookok okok oookokok okokokoook okokok okoookoook").ookook
end
class Enumerator
    alias_method :ook, ookoook("okokokok okok oookoooook").ookook
    alias_method :oook, ookoook("okoooookok okokoook oookokoook oookoook ok okokoook oooooooook oookok okokok oookoookok").ookook
end
class String
    alias_method :ook, ookoook("oookokoook okoooooook ok okokoook").ookook
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

ook = $stdin.readlines.ook { |ook| ook.ook }

#ook 
puts ook.ook { |ook| OOK.times.inject(ook) { |ook| oook(ook) } }.oookook

ook = ook.ook { |ook| Ook.new(OOK) { ook = oook(ook); ook % (OOOK*OOOK*OOOK+OOOK) } }

oook = Oook.new(OOOK-OOOK)

ook.ookook do |ook|
    ookook = {}
    ook.oook(OOOK).ook { |ook, oook| oook - ook}.oook(OOOK+OOOK).oook do |oookook,oookoook|
        unless ookook[oookook]
            oook[oookook] += ook[oookoook+OOOK+OOOK]
            ookook[oookook] = OOOK
        end
    end
end
#ook ook
puts oook.ook.oookoook

