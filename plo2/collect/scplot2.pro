PRO scplot2, f1,pos1,pos2,xpos,ypos,nl1,nl2,names,titl,xtitl,ytitl,glatt

COMMON program_par, nx,nxn,nxf, ny,nyn,nyf, x,y, xf,yf, xn,yn, iox,ioy, $
                    ioxf,ioyf, run, time

;--- velocities on either side and average velocities---

        fa=f1 & if glatt eq 'y' then  fa=smooth(fa,3)
        fa=interpolate(fa,ioxf,ioyf,/grid) 

	    fmax=max(fa) & fmin=min(fa)
        if ( (fmax-fmin) lt 0.000001) then begin
          fmax=fmax+0.05 & fmin=fmin-0.05 & endif
        if (!x.range(1) gt !x.range(0)) then $
	  if (!y.range(1) gt !y.range(0)) then nrot=0 else nrot=7
        if !x.range(1) lt !x.range(0) then $
	  if (!y.range(1) gt !y.range(0)) then nrot=5 else nrot=2

;       plot vzproj_msp     
        !P.POSITION=pos1
        IMAGE_C, rotate(fa,nrot)
        bmax=max(fa) & bmin=min(fa) &  bav=0.5*(bmax+bmin)
        if ( (bmax-bmin) lt 0.000001) then begin
          bmax=bmax+0.0000005 & bmin=bmin-0.0000005 & endif
        del=(bmax-bmin)/(nl2-1.)
        if (bmax*bmin ge 0.) or (abs(bmin) lt 0.2*abs(bmax)) then $
          cb=bav else cb=0.
        contour,fa,xf,yf,levels=findgen(nl2)*del+bmin,$
;        c_linestyle=findgen(nl2)*del+bmin lt cb,$
        c_linestyle=1,$
        title=titl,xstyle=1,ystyle=1,$
        xtitle=xtitl, /noerase
	xyouts,charsize=1.1,xpos(0),ypos(8),'time = '+string(time,'(f6.2)') 
	xyouts,charsize=1.0,xpos(1),ypos(7), ytitl

	!P.POSITION=pos2
	fmax=bmax & fmin=bmin
	ddel=(fmax-fmin) & del=ddel/float(nxf-1)
	ctab=findgen(nxf) & ctab=del*ctab+fmin & cbary=findgen(2,nxf)
	cbary(0,*)=ctab(*) & cbary(1,*)=ctab(*)
        IMAGE_C, cbary
	contour,cbary,[0,1],ctab,levels=findgen(nl1)*ddel/(nl1-1.)+fmin,$
	xstyle=1,ystyle=1,c_linestyle=1,xrange=[0,1],yrange=[fmin,fmax],$
        xtickname=names,xticks=1,ytickformat='(f6.3)',/noerase

  
return
end

