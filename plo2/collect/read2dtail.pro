PRO read2dtail, g1,g2,g3,h1,h2,h3, bx,by,bz,vx,vy,vz,rho,u,res

COMMON program_par, nx,nxn,nxf, ny,nyn,nyf, x,y, xf,yf, xn,yn, iox,ioy, $
                    ioxf,ioyf, run, time

   print, 'Input filenumber'
   read, fnumber
   name='magtap'+string(fnumber,'(i2.2)')
   openr, 8, name,/F77_UNFORMATTED
   readu, 8,  ny,nx,time
   print, 'dimension nx=',nx,'     ny=',ny

   x=fltarr(nx,/NOZERO) & y=fltarr(ny,/NOZERO)
   g1=fltarr(nx,/NOZERO) & g2=g1 & g3=g1 
   h1=fltarr(ny,/NOZERO) & h2=h1 & h3=h1 
   bx=fltarr(ny,nx,/NOZERO) & by=bx & bz=bx & vx=bx & vy=bx & vz=bx
   rho=bx & u=bx & res=bx

   readu, 8,  y,h1,h2,h3,h3,h3,h3, x,g1,g2,g3,g3,g3,g3 
  print, 'after read x'
;  print, y
   readu, 8,  by,bx,bz
  print, 'after read b'
   readu, 8,  vy,vx,vz
  print, 'after read v'
   readu, 8,  rho,u,res
  print, 'after read rho'
   close, 8
   vx=vx/rho &  vz=vz/rho & vy=vy/rho 

return
end

