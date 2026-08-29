g1 := [
[-1,0,0,-1,-1],
[1,1,1,0,2],
[0,0,-1,-1,-1],
[0,0,0,0,1],
[0,0,0,1,0]
];;
g2 := [
[0,-1,-1,0,-1],
[-1,0,-1,0,-1],
[0,0,0,0,1],
[0,0,-1,-1,-1],
[0,0,1,0,0]
];;
G := Group([g1,g2]);;
Print("size=", Size(G), " id=", IdGroup(G), "\n");
r := CaratQClassCatalog(G, 7);;
Print(r, "\n");
Print("families-bound=", IsBound(CaratCrystalFamiliesFlat), "\n");
Print("families-type=", TypeObj(CaratCrystalFamiliesFlat), "\n");
Print("families-length=", Length(CaratCrystalFamiliesFlat), "\n");
Print("family-position=", Position(CaratCrystalFamiliesFlat, "2-2;1;1;1"), "\n");
Print("families-bound-positions=", PositionsBound(CaratCrystalFamilies), "\n");
Print("dimension-five-length=", Length(CaratCrystalFamilies[5]), "\n");
Print("dimension-five-position=", Position(CaratCrystalFamilies[5], "2-2;1;1;1"), "\n");
zs := ZClassRepsQClass(r.group);;
Print("zclass-count=", Length(zs), "\n");
for i in [1..Length(zs)] do
  c := RepresentativeAction(GL(5,Integers), G, zs[i]);
  if c <> fail then
    Print("zclass-index=", i, " conjugator=", c, "\n");
  fi;
od;
Gdual := Group(List([g1,g2], x -> TransposedMat(Inverse(x))));;
rdual := CaratQClassCatalog(Gdual, 7);;
Print("dual-qclass=", rdual.qclass, " dual-family=", rdual.familysymb, "\n");
zsdual := ZClassRepsQClass(rdual.group);;
for i in [1..Length(zsdual)] do
  c := RepresentativeAction(GL(5,Integers), Gdual, zsdual[i]);
  if c <> fail then
    Print("dual-zclass-index=", i, " dual-conjugator=", c, "\n");
    Print("dual-zclass-generators=", GeneratorsOfGroup(zsdual[i]), "\n");
  fi;
od;
QUIT;
