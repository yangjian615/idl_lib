PRO plotvarsim, min, max, strnn,coordstrn,base,eb1,eb2,eb3,vht,ischt,$
                htpresent,varpresent

COMMON procommon, nsat,startime,itot,pi,ntmax, $
                  rhobd,pbd,vxbd,vybd,vzbd,bxbd,bybd,bzbd, $
                  xsi,ysi,zsi,vxsi,vysi,vzsi, $
                  time,bxs,bys,bzs,vxs,vys,vzs,rhos,ps,bs,ptots, $
                  jxs,jys,jzs,xs,ys,zs,cutalong
COMMON ref, br,vr,rhor,pr,babr,ptotr,pbr,tempr,beta,t, $
            jr,er,rsat,vrsat,index,starttime,xtit,withps,$
            satchoice,withunits
COMMON pltvar, vplot,bplot

    names=strarr(15) & names=replicate(' ',15)
    if coordstrn eq 'GSM' then begin
      ix='X' & iy='Y' & iz='Z'
    endif else begin
      ix='I' & iy='J' & iz='K'
    endelse

    if withunits eq 'n' then begin
      tempustr= '' & densustr= '' & pustr   = ''
      bustr   = '' & vustr   = '' & justr   = ''
   endif
    if withunits eq 'y' then begin
      tempustr= 'keV' & densustr= 'cm!U-3!N' & pustr   = 'nPa'
      bustr   = 'nT' & vustr   = 'km/s' & justr   = 'nA/m!U2!N'
   endif


;plotcoordinates for SAT COORDINATES
    ddr=20.
    dqx=0.075 & dqy=0.12 & ddx=0.03
    xl1=0.77 & xu1=xl1+dqx
    xl2=xu1+ddx & xu2=xl2+dqx
    yl1=0.82 & yu1=yl1+dqy
;plotcoordinates for SAT SEPARATION
    dqx=0.075 & dqy=0.12 & ddx=0.03
    xsl1=0.54 & xsu1=xsl1+dqx
    xsl2=xsu1+ddx & xsu2=xsl2+dqx
    yl1=0.82 & yu1=yl1+dqy

;plotcoordinates for B line plots
    dpx=0.41  & dpy=0.165
    xab=0.545 & xeb=xab+dpx 
    ylo1=0.55 & yup1=ylo1+dpy
    ylo2=ylo1-dpy & yup2=ylo1
    ylo3=ylo2-dpy & yup3=ylo2
    ylo4=ylo3-dpy & yup4=ylo3

;plotcoordinates for P line plots
    dpx=0.41  & dpy=0.165
    xap=0.055 & xep=xap+dpx 
    ylo0=0.715 & yup0=ylo0+dpy
    ylo1=ylo0-dpy & yup1=ylo0
    ylo2=ylo1-dpy & yup2=ylo1
    ylo3=ylo2-dpy & yup3=ylo2
    ylo4=ylo3-dpy & yup4=ylo3


      tvlct,[0,255,0,100,0,255,230],[0,0,255,100,255,0,230],$
                                    [0,0,0,255,255,255,0]
      red   = 1
      green = 2
      blue  = 3
      yebb  = 4
      grbl  = 5
      yell  = 6
    col1=0 & col2=yell & col3=green & col4=red
    
    erase
    !P.REGION=[0.,0.,1.0,1.0]
    !P.MULTI=[0,1,1]
    !P.CHARSIZE=1.
    !P.CHARTHICK=1.
    !P.FONT=-1
;    !X.TICKS=0
;    !Y.TICKS=0
    !X.TICKlen=0.04
    !Y.TICKlen=0.03
    !X.THICK=1
    !Y.THICK=1
    if withps eq 'y' then begin
      !P.CHARSIZE=0.8
      !P.CHARTHICK=3.
      !P.THICK=4.
      !P.FONT=3
      !X.THICK=3
      !Y.THICK=3
    endif
         
    print, 'min+max', min,max
    print, 't:', t
    intbd,min,max,itot,t,ips,ipe
    del = max-min
; PLASMA DATA

;   Temperature and Density
    !P.POSITION=[xap,ylo0,xep,yup0]
    dum=0.
    if ipe ge ips then begin
      tt1=fltarr(ipe-ips+1) & dum=[dum,rhor(ips:ipe)] & endif
    bmax=max(dum) & bmin=min(dum) & if bmax eq 0.0 then bmax=1.
    bmin=0.01 & delb=bmax-bmin & rhomax=bmax+0.05*delb & rhomin=bmin-0.05*delb
    addsc='' & if coordstrn ne 'GSM' then addsc=''
    plot, [min,max],[rhomin,rhomax],/nodata,ytick_get=yy,$
          xrange=[min,max],yrange=[rhomin,rhomax],$
	  title=strnn+' - '+coordstrn+addsc,$
	  xstyle=1,ystyle=9,xtickname=names,/noerase
;	  xstyle=1,ystyle=2,xtickname=names,ytickname=names,/noerase
    if ipe ge ips then $
      oplot, t(ips:ipe), rhor(ips:ipe),line=0,color=blue
    xt0=min-0.10*del  &   yt0=bmin+0.62*delb    
    xt1=min-0.12*del  &   yt1=bmin+0.45*delb    
    xyouts, xt0, yt0, 'N',charsize=1
    xyouts, xt1, yt1,densustr,charsize=0.9
    xt0=max+0.08*del  &   yt0=bmin+0.62*delb    
    xt1=max+0.07*del  &   yt1=bmin+0.45*delb    
    xyouts, xt0, yt0, 'T',charsize=1
    xyouts, xt1, yt1,tempustr,charsize=0.9

    tempmax=max(tempr) & print, 'Temp, max: ',tempmax
    temprange = tempmax   & tempscale = (rhomax-rhomin)/1.1/temprange
	axis,yaxis=1,yrange=[-0.05,1.05*temprange],ystyle=1
    if ipe ge ips then $
	oplot, t(ips:ipe), tempscale*tempr(ips:ipe), line=2,color=red
;    print,'rho:',yy  & ysize=size(yy) & nyy=ysize(1) & yy1=yy-yy(0) 
;    if (yy1(1) ge 0.0001) and (yy1(1) le 0.001)  then yff=f(7.4)
;    if (yy1(1) ge 0.001) and (yy1(1) le 0.01)  then yff=f(6.3)
;    if (yy1(1) ge 0.01) and (yy1(1) le 0.1)  then yff=f(5.2)
;    if (yy1(1) ge 0.1) and (yy1(1) le 1.)  then yff=f(4.1)
;    if (yy1(1) ge 1.) and (yy1(1) le 10.)  then yff=f(3.0)

;   V
    !P.POSITION=[xap,ylo1,xep,yup1]
    dum=0.
    if ipe ge ips then begin
      tt1=fltarr(ipe-ips+1) & tt1(*)=vplot(0,ips:ipe) & dum=[dum,tt1] 
      tt2=fltarr(ipe-ips+1) & tt2(*)=vplot(1,ips:ipe) & dum=[dum,tt2] 
      tt3=fltarr(ipe-ips+1) & tt3(*)=vplot(2,ips:ipe) & dum=[dum,tt3] 
    endif
    bmax=max(dum) & bmin=min(dum) 
    if bmax le bmin then begin & bmax=1. & bmin=-1. & endif
    delb=bmax-bmin   & bmax=bmax+0.05*delb & bmin=bmin-0.05*delb
    plot, [min,max],[bmin,bmax],/nodata, $
          xrange=[min,max],yrange=[bmin,bmax],ytick_get=vv,$
	  xstyle=1,ystyle=1,xtickname=names,/noerase 
    if ipe ge ips then begin
      oplot, t(ips:ipe), vplot(0,ips:ipe),line=0
      oplot, t(ips:ipe), vplot(1,ips:ipe),line=0,color=blue
      oplot, t(ips:ipe), vplot(2,ips:ipe),line=0,color=red
    endif
    xt0=min-0.12*del  &   yt0=bmin+0.62*delb    
    xt1=min-0.15*del  &   yt1=bmin+0.45*delb    
    xyouts, xt0, yt0, 'V', charsize=1
    xyouts, xt1, yt1,vustr,charsize=0.9
    print,'V:',vv

;   B
    !P.POSITION=[xap,ylo2,xep,yup2]
    dum=0.
    if ipe ge ips then begin
      tt1=fltarr(ipe-ips+1) & tt1(*)=bplot(0,ips:ipe) & dum=[dum,tt1] 
      tt2=fltarr(ipe-ips+1) & tt2(*)=bplot(1,ips:ipe) & dum=[dum,tt2] 
      tt3=fltarr(ipe-ips+1) & tt3(*)=bplot(2,ips:ipe) & dum=[dum,tt3] 
    endif
    bmax=max(dum) & bmin=min(dum) 
    if bmax le bmin then begin & bmax=1. & bmin=-1. & endif
    delb=bmax-bmin  & bmax=bmax+0.05*delb & bmin=bmin-0.05*delb
    plot, [min,max],[bmin,bmax],/nodata, $
          xrange=[min,max],yrange=[bmin,bmax],ytick_get=vv,$
	  xstyle=1,ystyle=1,xtickname=names,/noerase 
    if ipe ge ips then begin
      oplot, t(ips:ipe), bplot(0,ips:ipe),line=0
      oplot, t(ips:ipe), bplot(1,ips:ipe),line=0,color=blue
      oplot, t(ips:ipe), bplot(2,ips:ipe),line=0,color=red
    endif
    xt0=min-0.10*del  &   yt0=bmin+0.62*delb    
    xt1=min-0.11*del  &   yt1=bmin+0.45*delb    
    xyouts, xt0, yt0, 'B',charsize=1
    xyouts, xt1, yt1,bustr,charsize=0.9
    print,'B:',vv

;   Pressure, pr,pbr,ptotr
    !P.POSITION=[xap,ylo3,xep,yup3]
    dum=0. 
    if ipe ge ips then dum=[dum,ptotr(ips:ipe)]
    bmax=max(dum) & if bmax eq 0.0 then bmax=1.
    bmin=0.0 & delb=bmax-bmin  & bmax=bmax+0.05*delb & bmin=bmin-0.05*delb
    if satchoice eq 'b' then $
      plot, [min,max],[bmin,bmax],/nodata,ytick_get=vv, $
          xrange=[min,max],yrange=[bmin,bmax],$
	  xstyle=1,ystyle=1,xtitle=xtit,/noerase 
    if satchoice ne 'b' then $
      plot, [min,max],[bmin,bmax],/nodata,ytick_get=vv, $
          xrange=[min,max],yrange=[bmin,bmax],$
	  xstyle=1,ystyle=1,xtickname=names,/noerase 
    if ipe ge ips then begin
      oplot, t(ips:ipe), pr(ips:ipe),line=0
      oplot, t(ips:ipe), pbr(ips:ipe),line=2,color=blue
      oplot, t(ips:ipe), ptotr(ips:ipe),line=3,color=red
    endif
    xt0=min-0.10*del  &   yt0=bmin+0.62*delb    
    xt1=min-0.12*del  &   yt1=bmin+0.45*delb    
    xyouts, xt0, yt0, 'P',charsize=1
    xyouts, xt1, yt1, pustr,charsize=0.9
    print,'P:',vv

;   J
    !P.POSITION=[xap,ylo4,xep,yup4]
    if (satchoice eq '2' or satchoice eq '3') then begin 
      jplot=jr & jplot=base#jplot
      if ipe ge ips then begin
        bmax=max(jplot(*,ips:ipe)) & bmin=min(jplot(*,ips:ipe))
      endif else begin
        bmax=1.e-9 & bmin=-1.e-9
      endelse 
      delb=bmax-bmin  & bmax=bmax+0.05*delb & bmin=bmin-0.05*delb
      plot, [min,max],[bmin,bmax],/nodata, ytick_get=vv,$
	  xrange=[min,max], yrange=[bmin,bmax], $
	  xstyle=1,ystyle=1,xtitle=xtit,/noerase
      if ipe ge ips then begin
        oplot, t(ips:ipe), jplot(0,ips:ipe)
        oplot, t(ips:ipe), jplot(1,ips:ipe),line=2,color=blue
        oplot, t(ips:ipe), jplot(2,ips:ipe),line=3,color=red
      endif
      xt0=min-0.10*del  &   yt0=bmin+0.62*delb    
      xt1=min-0.14*del  &   yt1=bmin+0.45*delb    
      xyouts, xt0, yt0, 'J',charsize=1
      xyouts, xt1, yt1, justr,charsize=0.9
    endif




; MAGNETIC DATA really TTT
    del = max-min    
;   B
    !P.POSITION=[xab,ylo1,xeb,yup1]
    dum=0.
    if ipe ge ips then begin
      tt1=fltarr(ipe-ips+1) & tt1(*)=bplot(0,ips:ipe) & dum=[dum,tt1] 
      tt2=fltarr(ipe-ips+1) & tt2(*)=bplot(1,ips:ipe) & dum=[dum,tt2] 
      tt3=fltarr(ipe-ips+1) & tt3(*)=bplot(2,ips:ipe) & dum=[dum,tt3] 
    endif
    bmax=max(dum) & bmin=min(dum) 
    if bmax le bmin then begin & bmax=1. & bmin=-1. & endif
    delb=bmax-bmin  
    plot, [min,max],[bmin,bmax],/nodata, $
          xminor=xminor, xrange=[min,max],yrange=[bmin,bmax],$
	  title=strnn+' - '+coordstrn+addsc,$
	  xstyle=1,ystyle=2,xtickname=names,/noerase 
    if ipe ge ips then begin
      oplot, t(ips:ipe), bplot(0,ips:ipe),line=0,thick=1
      oplot, t(ips:ipe), bplot(1,ips:ipe),line=0,color=col2,thick=1
      oplot, t(ips:ipe), bplot(2,ips:ipe),line=0,color=col3,thick=1
    endif
    xt0=min-0.10*del  &   yt0=bmin+0.62*delb    
    xt1=min-0.10*del  &   yt1=bmin+0.73*delb    
    xyouts, xt0, yt0, 'B!D'+ix+'!N',charsize=1
    xyouts, xt1, yt1, 'nT',charsize=0.9

;   CURRENT DENSITY
    if (satchoice eq '2' or satchoice eq '3') then begin 
      jplot=jr & jplot=base#jplot
      !P.POSITION=[xab,ylo4,xeb,yup4]
      if ipe ge ips then begin
        bmax=max(jplot(*,ips:ipe)) & bmin=min(jplot(*,ips:ipe))
      endif else begin
        bmax=1.e-9 & bmin=-1.e-9
      endelse 
      delb=bmax-bmin 
      plot, [min,max],[bmin,bmax],/nodata, $
	  xrange=[min,max], yrange=[bmin,bmax], $
	  xstyle=1,ystyle=2,$;xtickname=names, $
	  xtitle=xtit,/noerase
      if ipe ge ips then begin
        oplot, t(ips:ipe), jplot(0,ips:ipe)
        oplot, t(ips:ipe), jplot(1,ips:ipe),line=2,color=blue,thick=1
        oplot, t(ips:ipe), jplot(2,ips:ipe),line=3,color=red,thick=1
      endif
      xt0=min-0.10*del  &   yt0=bmin+0.62*delb    
      xt1=min-0.13*del  &   yt1=bmin+0.74*delb    
      xyouts, xt0, yt0, 'J',charsize=1
      xyouts, xt1, yt1, 'nA/m!U2!N',charsize=0.9
    endif

  return
end

