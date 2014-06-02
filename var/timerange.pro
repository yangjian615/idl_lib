PRO timerange, time,tfac, tmin,tmax,it1,it2,nt,success
  
     t=tfac*time
     hh=size(time)
     nt=hh(1)
     success='yes'
     it1=nt-2
     it2=1
     
     print, 'Input tmin,tmax:'
     read, tmin,tmax
     if (tmin lt t(0)) or (tmin gt t(nt-4)) then begin
        print, 'TMIN has a wrong value!!!' & success='none' & endif
     if (tmax lt t(2)) or (tmax gt t(nt-1)) then begin
        print, 'TMAX has a wrong value!!!' & success='none' & endif
     if tmin ge tmax then begin
        print,'TMIN is larger then TMAX!!!' & success='none' & endif
        
     if success eq 'yes' then begin
      while t(it1-1) gt tmin do it1=it1-1
      while t(it2+1) lt tmax do it2=it2+1
;      print, tmin
;      print, t(it1-1),t(it1),t(it1+1)
;      print, tmax
;      print, t(it2-1),t(it2),t(it2+1)
      if it2-it1 lt 3 then begin
         success='none' & print, 'Time limits are too close' & endif
     endif
     if success eq 'none' then begin
        it1=0 & it2=nt-1
        tmin=t(0) & tmax=t(it2)
     endif
     nt=it2-it1+1
return
end

  
