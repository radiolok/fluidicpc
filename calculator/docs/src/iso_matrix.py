"""Иллюстрация: силуэт цифры «5» отбрасывает тень на матрицу трубочек 5×7 (тёмные трубочки закрыты)."""
import math
from render import render, img
c=math.cos(math.pi/6); S=30
G="##### #.... ####. ....# ....# #...# .###.".split()
on=lambda r,k: G[r][k]=='#'
D=7.0; L=0.5; R=0.27; T=0.35; b=0.5
def P(x,y,z): return ((x-z)*c*S, ((x+z)*0.5-y)*S)
items=[]
def poly(pts,fill,extra=''):
    return '<polygon points="%s" fill="%s" %s/>'%(' '.join('%.1f,%.1f'%p for p in pts),fill,extra)
def quad(a,bb,cc,d,fill,extra=''): return poly([P(*a),P(*bb),P(*cc),P(*d)],fill,extra)
out=[]
# wall plate: x -0.5..5.5, y -0.5..7.5, z -0.5..0
x0,x1,y0,y1,zb=-0.5,5.5,-0.5,7.5,-0.5
out.append(quad((x0,y1,zb),(x1,y1,zb),(x1,y1,0),(x0,y1,0),'#F1EFE8','stroke="#888780" stroke-width="1"'))
out.append(quad((x1,y0,zb),(x1,y1,zb),(x1,y1,0),(x1,y0,0),'#B4B2A9','stroke="#888780" stroke-width="1"'))
out.append(quad((x0,y0,0),(x1,y0,0),(x1,y1,0),(x0,y1,0),'#D3D1C7','stroke="#888780" stroke-width="1"'))
# shadow on wall at z=0 : pixel squares shifted down by b*0 (silhouette placed so shadow at z=L aligned) -> at z=0 shift -b*L
sh=[]
for r in range(7):
  for k in range(5):
    if on(r,k):
      X,Y=k,6-r; dy=-b*L
      sh.append(quad((X,Y+dy,0),(X+1,Y+dy,0),(X+1,Y+1+dy,0),(X,Y+1+dy,0),'#444441'))
out.append('<g opacity="0.55">'+''.join(sh)+'</g>')
def ell(cx,cy,z,n=24): return [P(cx+R*math.cos(t),cy+R*math.sin(t),z) for t in [2*math.pi*i/n for i in range(n)]]
def hull(pts):
    pts=sorted(set(pts))
    def cr(o,a,b_): return (a[0]-o[0])*(b_[1]-o[1])-(a[1]-o[1])*(b_[0]-o[0])
    lo=[];up=[]
    for p in pts:
        while len(lo)>=2 and cr(lo[-2],lo[-1],p)<=0: lo.pop()
        lo.append(p)
    for p in reversed(pts):
        while len(up)>=2 and cr(up[-2],up[-1],p)<=0: up.pop()
        up.append(p)
    return lo[:-1]+up[:-1]
tubes=[]
for r in range(7):
  for k in range(5):
    cx,cy=k+0.5,6-r+0.5; s=on(r,k)
    side,cap,hole=('#854F0B','#BA7517','#2C2C2A') if s else ('#EF9F27','#FAC775','#633806')
    h=hull(ell(cx,cy,0)+ell(cx,cy,L))
    g=poly(h,side,'stroke="#633806" stroke-width="0.6"')
    g+=poly(ell(cx,cy,L),cap,'stroke="#633806" stroke-width="0.6"')
    inner=[(P(cx+R*0.62*math.cos(t),cy+R*0.62*math.sin(t),L)) for t in [2*math.pi*i/24 for i in range(24)]]
    g+=poly(inner,hole)
    tubes.append((cx+cy,g))
for _,g in sorted(tubes): out.append(g)
# light rays: horizontal on screen; from far left through silhouette edges to shadow
def sil(X,Y,z): return (X, Y+b*(z-L), z)   # point on silhouette plane mapping to shadow point (X,Y) at z=L
LX=P(*sil(2.5,3.5,D+T+3.6))[0]
rays=[]
for (X,Y) in [(0,7),(5,7),(4,4.5),(0.5,0.0),(1,4.5)]:
    a=P(*sil(X,Y,D+T+3.2)); e=P(X,Y,L); a=(LX+22,a[1])
    rays.append('<line x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f" stroke="#EF9F27" stroke-width="1.2" stroke-dasharray="5 4"/>'%(a+e))
out.append(''.join(rays))
# silhouette slab: z from D to D+T, squares
sq=[]
for r in range(7):
  for k in range(5):
    if on(r,k):
      X,Y=k,6-r
      A=lambda x,y,z: sil(x,y,z)
      # use silhouette coordinates: square spans X..X+1, Y'..Y'+1 where Y' offset by b*(D-L)
      oy=b*(D-L); z0,z1=D,D+T
      top=quad((X,Y+1+oy,z0),(X+1,Y+1+oy,z0),(X+1,Y+1+oy,z1),(X,Y+1+oy,z1),'#7F77DD') if (r==0 or not on(r-1,k)) else ''
      rt=quad((X+1,Y+oy,z0),(X+1,Y+1+oy,z0),(X+1,Y+1+oy,z1),(X+1,Y+oy,z1),'#3C3489') if (k==4 or not on(r,k+1)) else ''
      fr=quad((X,Y+oy,z1),(X+1,Y+oy,z1),(X+1,Y+1+oy,z1),(X,Y+1+oy,z1),'#534AB7')
      sq.append((X+Y,top+rt,fr))
sq.sort()
out.append(''.join(t for _,t,_ in sq)); out.append(''.join(f for _,_,f in sq))
# lamp at far left
lx,ly=P(*sil(2.5,3.5,D+T+3.6))
body=''.join(out)
import re
nums=[float(v) for v in re.findall(r'(-?\d+\.\d),(-?\d+\.\d)',body) for v in v]
xs=nums[0::2]; ys=nums[1::2]
mnx,mxx,mny,mxy=min(xs+[lx-30]),max(xs),min(ys),max(ys)
pad=30; W=mxx-mnx+2*pad; H=mxy-mny+2*pad
sc=680/W
svg='<svg width="100%%" viewBox="0 0 680 %d" role="img"><title>Струйный перцептрон: силуэт цифры и матрица трубочек</title><desc>Изометрия: светлая пластина с матрицей 5 на 7 латунных трубочек, перед ней фиолетовый силуэт цифры 3, пунктирные лучи света, тень цифры накрывает трубочки</desc><g transform="scale(%.4f) translate(%.1f,%.1f)">'%(H*sc,sc,pad-mnx,pad-mny)
lamp='<g><circle cx="%.1f" cy="%.1f" r="16" fill="#FAC775" stroke="#BA7517" stroke-width="1.5"/>'%(lx,ly)+''.join('<line x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f" stroke="#BA7517" stroke-width="1.5" stroke-linecap="round"/>'%(lx+22*math.cos(t),ly+22*math.sin(t),lx+30*math.cos(t),ly+30*math.sin(t)) for t in [i*math.pi/4 for i in range(8)])+'</g>'
svg+=body+lamp+'</g></svg>'
open(img('matrix_shadow.svg'),'w').write(svg)
render(img('matrix_shadow.svg'), img('matrix_shadow.png'))
