Pro jprof,ps=ps
; Program jprof
; This program generates one-dimensional profiles of the current density
; generated by the tsyrelax program suite.
; Version 1
; Based on Version 2 of col7f
; by Antonius Otto and Fred Hall IV
; 13 September 2004
;
; START OF MAIN PROGRAM
;
; program needs update for vect, and laser 600 resolution
COMMON program_par, nx,nxn,nxf, ny,nyn,nyf, nz,nzn,nzf,$
                    x,y,z, xf,yf,zf, xn,yn,zn, iox,ioy,ioz, $
                    ioxf,ioyf,iozf, run, time
COMMON program_var, fp1,fp2,xsu,ysu,f0,xchoice,ychoice,far1,far2,xar,yar,$
                    cutata,cutatb

; GRID FOR VELOCITY VECTORS
  nxn = 21   &   nyn = 21   &   nzn=21 
  fn1=fltarr(nxn,nyn) & fn2=fn1
; GRID FOR CONTOUR AND SURFACE PLOTS
  nxf = 121   &   nyf = 121  &  nzf=121 
  fa=fltarr(nxf,nyf) & fb=fa
  nx=long(131) & ny=long(126) & nz=long(126) 
  time=0.0 & fnumber=1
  fgroup='1' & group='1'
  name='' & smo='' & again='y' & withps='n' & run=''  
  nl1=17  &  nl2=9  &  
  closeps='n' & jnew='y' & newplot='a' & coltab='o' & intplot='f'
  colps ='n' & grayplot ='n' 
  plane='x' & whatcut='x' & choice='f' & igrid=31
  jnew= 'y' & enew= 'y'
  names=strarr(15) &  names=replicate(' ',15)
  ctab=findgen(nxf) &   cbary=fltarr(2,nxf)
  contonly = 'n' & orient='l'
  wlong=900 & wshort=720 & wfact=1.0 &  wxf=1.0 & wyf=1.0 & psfact=0.9
  wsize=[700,900] & wsold=[0,0] & wino=0 & srat0=1.1



;-----------PARAMETER----------------
  xmin = -40.0 & ymin = -15.0  & zmin = 0.0
  xmax = 0.0 & ymax = 15.0   & zmax = 12.0

; Specify if boundary conditions will be imposed here.
  ibc = 0

; Specify the coordinate along which the profile will be taken.
  pltsw = 2


; READ INPUT DATA OF DIMENSION NX, NY,NZ
  read3d, dx,dxh,dy,dyh,dz,dzh, bx,by,bz,sx,sy,sz,rho,u,res

  ex=bx & ey=bx & ez=bx & jx=bx & jy=bx & jz=bx
  testbd3, nx,ny,nz,x,y,z,xmin,xmax,ymin,ymax,zmin,zmax
    
  printstuff, bx,by,bz,sx,sy,sz,rho,u,res


; GRID FOR VELOCITY VECTORS 
  grid3d, x,y,z,xmin,xmax,ymin,ymax,zmin,zmax,$
          nxn,nyn,nzn,xn,yn,zn,iox,ioy,ioz,dxn,dyn,dzn
; GRID FOR CONTOUR/SURFACE PLOTS
  grid3d, x,y,z,xmin,xmax,ymin,ymax,zmin,zmax,$
          nxf,nyf,nzf,xf,yf,zf,ioxf,ioyf,iozf,dxf,dyf,dzf

  f1=bx & f2=by & f3=bz & p=2*u^(5.0/3.0) & f4=p
  jmag=bx


; Calculate the current density.

  f1 = shift(bz,0,-1,0)-shift(bz,0,1,0)
  for j=1,ny-2 do f3(*,j,*)=dy(j)*f1(*,j,*)
  f2 = shift(by,0,0,-1)-shift(by,0,0,1)
  for k=1,nz-2 do f4(*,*,k)=dz(k)*f2(*,*,k)
  jx = f3-f4

  f1 = shift(bx,0,0,-1)-shift(bx,0,0,1)
  for k=1,nz-2 do f3(*,*,k)=dz(k)*f1(*,*,k)
  f2 = shift(bz,-1,0,0)-shift(bz,1,0,0)
  for i=1,nx-2 do f4(i,*,*)=dx(i)*f2(i,*,*)
  jy = f3-f4

  f1 = shift(by,-1,0,0)-shift(by,1,0,0)
  for i=1,nx-2 do f3(i,*,*)=dx(i)*f1(i,*,*)
  f2 = shift(bx,0,-1,0)-shift(bx,0,1,0)
  for j=1,ny-2 do f4(*,j,*)=dy(j)*f2(*,j,*)
  jz = f3-f4



; Conditional imposition of boundary conditions on the current density.
  if (ibc eq 1) then begin $
    jx([0,nx-1],*,*) = jx([1,nx-2],*,*)
    print,'after jx'
    jy([0,nx-1],*,*) = jy([1,nx-3],*,*)
    jz([0,nx-1],*,*) = jz([1,nx-3],*,*)
    jx(*,[0,ny-1],*) = jx(*,[1,ny-2],*)
    jy(*,[0,ny-1],*) = jy(*,[1,ny-2],*)
    jz(*,[0,ny-1],*) = jz(*,[1,ny-2],*)
    jx(*,*,0)=jx(*,*,2) & jx(*,*,nz-1)=jx(*,*,nz-3) 
    jy(*,*,0)=jy(*,*,2) & jy(*,*,nz-1)=jy(*,*,nz-3) 
    jz(*,*,0)=0 & jz(*,*,nz-1)=jz(*,*,nz-3) 
    jy(nx-2,*,*)=jy(nx-3,*,*)
    jz(nx-2,*,*)=jz(nx-3,*,*)
    jnew='n'
  endif


; Calculate the magnitude of the current density
  for k=0,nz-1 do begin
    for j=0,ny-1 do begin
      for i=0,nx-1 do begin
        jsq = jx(i,j,k)*jx(i,j,k) + jy(i,j,k)*jy(i,j,k) $
            + jz(i,j,k)*jz(i,j,k)
        jmag(i,j,k) = sqrt(jsq)
      endfor
    endfor
  endfor




; Specify the intersecting planes defining the line along which the
; profile will be taken.
  xpl = 81
  ypl = 61
  zpl = 5
  print,'x-coordinate plane: x = ',x(xpl)
  print,'y-coordinate plane: y = ',y(ypl)
  print,'z-coordinate plane: z = ',z(zpl)


; Enable printer if specified.
  if keyword_set(ps) then begin
    set_plot,'ps'
    device,/portrait
    device,/inches,xsize=6.0,ysize=5.5,xoffset=1.0,yoffset=4.0
    device,filename='jprof.ps'
  endif


; Generate the plots.

if (pltsw eq 1) then $
  plot,x,jmag(*,ypl,zpl), $
       Title='Magnitude of the current density', $
       Xtitle='x (R!DE!N)', $
       Ytitle='j', $
;      Xrange=[x(0),x(nx-1)]
;      Yrange=[2.0,3.0]
       PSYM=-2

if (pltsw eq 2) then $
  plot,y,jmag(xpl,*,zpl), $
       Title='Magnitude of the current density', $
       Xtitle='y (R!DE!N)', $
       Ytitle='j', $
;      Xrange=[y(0),y(ny-1)]
;      Yrange=[2.5,4.0], $
       PSYM=-2

if (pltsw eq 3) then $
  plot,z,jmag(xpl,ypl,*), $
       Title='Magnitude of the current density', $
       Xtitle='z (R!DE!N)', $
       Ytitle='j'
;      Xrange=[z(0),z(nz-1)]
;      Yrange=[2.8,4.5], $
;      PSYM=-2


; Close printer device if opened and reset normal plotting
if keyword_set(ps) then begin
  device,/close
  set_plot,'x'
endif



end


