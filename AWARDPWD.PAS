{.$M 1024,0,0}
{.$C MOVEABLE DEMANDLOAD DISCARDABLE}
{.$Y-,D-,X+,L-,E+,N-,G+,O-,F-,I-,Q-,R-,S-,T-,V-}
Const Minus : Array[1..8] Of LongInt = (32,160,672,2720,10912,43680,174752,699040);
      Step  : Array[1..8] Of LongInt = (1,4,16,64,256,1024,4096,16384);

Function ReadCmos(Adr:Byte):Byte;
Begin
  Port[$70]:=Adr;
  asm nop;nop;nop end;
  ReadCmos:=Port[$71];
End;

Var b1,b2: Byte;
    tempp,Psw,t,i,j: Word;

Begin
  writeln(#13#10'AWARD BIOS Password calculator v1.1p');
  writeln('(c) 1999 by NiKe');
  Write('Password : ');
  b1:={ReadCmos(28)}1;
  b2:={ReadCmos(29)}1;
  b1:=$21; b2 := $24;
  Psw:=b2*256+b1;
  for tempp := $1000 to $1005 do
  begin
  psw := tempp;
  For t:=6 DownTo 1 Do If Psw>Minus[t] Then Break;
  Psw:=Psw-Minus[t];
  For i:=t DownTo 1 Do
  Begin
    For j:=94 DownTo 0 Do
      If j*Step[i]<=Psw
        Then Break;
    Write(Chr(j+32));
    Psw:=Psw-j*Step[i];
  End;
  Write(#13#10'           ');
  for b1:=1 to t do write('~');
  writeln;
  end;
  WriteLn(#13#10'Thats all girls...');
End.