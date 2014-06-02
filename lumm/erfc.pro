function erfc, x

; (1-erf(x)) * exp(x^2)

a1=.254829592
a2=-.284496736
a3=1.421413741
a4=-1.453152027
a5=1.061405429
p=.3275911
t=1./(1.+p*x)
return, ((((a5*t+a4)*t+a3)*t+a2)*t+a1)*t
end
