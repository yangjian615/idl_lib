PRO vcfplotc, f1,f2,fv1,fv2,pos1,pos2,xpos,ypos,nl1,nl2,names, $
             titl,xtitl,ytitl,glatt,aval

COMMON program_par, nx,nxn,nxf, ny,nyn,nyf, x,y, xf,yf, xn,yn, iox,ioy, $
                    ioxf,ioyf, run, time

;--- velocities on either side and average velocities---
        fa=f1 & fb=f2 & fn1=fv1 & fn2=fv2
        if glatt eq 'y' then  fa=smooth(f1,3)
        if glatt eq 'y' then  fb=smooth(f2,3)
        fa=interpolate(fa,ioxf,ioyf,/grid) 
        fb=interpolate(fb,ioxf,ioyf,/grid)
        fn1=interpolate(fn1,iox,ioy,/grid)
        fn2=interpolate(fn2,iox,ioy,/grid)

	    fmax=max(fa) & fmin=min(fa)
        if ( (fmax-fmin) lt 0.0001) then begin
          fmax=fmax+0.0001 & fmin=fmin & endif
	
        if (!x.range(1) gt !x.range(0)) then $
	  if (!y.range(1) gt !y.range(0)) then nrot=0 else nrot=7
        if !x.range(1) lt !x.range(0) then $
	  if (!y.range(1) gt !y.range(0)) then nrot=5 else nrot=2

        ytf='(f6.1)'
        if ((abs(fmax) lt 1.) and (abs(fmin) lt 1.)) then ytf='(f6.3)'
        if ((abs(fmax) gt 10.) or (abs(fmin) gt 10.)) then ytf='(f6.1)'

;       colorbar        
        !P.POSITION=pos2
        ddel=(fmax-fmin) & del=ddel/float(nxf-1)
        ctab=findgen(nxf) & ctab=del*ctab+fmin  & cbary=findgen(2,nxf)
        cbary(0,*)=ctab(*) & cbary(1,*)=ctab(*)
        IMAGE_C, cbary
        contour,cbary,[0,1],ctab,levels=findgen(nl1)*ddel/(nl1-1.)+fmin,$
        c_linestyle=1,xstyle=1,ystyle=1,$
        xrange=[0,1],yrange=[fmin,fmax],$
        xtickname=names,xticks=1,ytickformat=ytf,/noerase
        
;       plot vz,magnetic field, and vel vectors       
        !P.POSITION=pos1
        IMAGE_C, rotate(fa,nrot)

        thickarr=fltarr(nl1) & thickarr(*)=1.0 & thickarr(nl1-1)=4.0
        bmax=max(fb) & bmin=min(fb) & del=(bmax-bmin)/(nl1-1.)
        bav=0.5*(bmax+bmin) 
        if ( (bmax-bmin) lt 0.0001) then begin
          bmax=bmax+0.0001 & del=(bmax-bmin)/(nl1-1.) & endif
        print, 'vecpot:', bmax, bmin, bav
        lvec=findgen(nl1)*del+bmin+del & lvec(nl1-1)=aval
        indsort=sort(lvec)
        lvec=lvec(indsort) & thickarr=thickarr(indsort)
        contour,fb,xf,yf,levels=lvec,$
          c_linestyle=0, c_thick=thickarr,$ 
          xstyle=1, ystyle=1,$
          xtitle=xtitl,thick=1.0,/noerase        
        fmax=sqrt(max(fn1^2+fn2^2))
        vect, fn1, fn2, xn, yn, length=0.9,$
        title=titl,/noerase
        
;	xyouts,charsize=1.1,xpos(2),ypos(8),'Max='+string(fmax,'(f4.2)')
;	xyouts,charsize=0.8,xpos(0),ypos(4),' '+string(fmax,'(f5.2)')
;	xyouts,charsize=0.8,xpos(0),ypos(0),'time' 
;	xyouts,charsize=0.8,xpos(0),ypos(1),' '+string(time,'(i3)') 
;	xyouts,charsize=0.8,xpos(0),ypos(2),run 
	xyouts,charsize=1.0,xpos(1),ypos(7),ytitl
;	xyouts,charsize=1.0,xpos(2),ypos(9),'time = '+string(time,'(i3)') 



  
return
end

