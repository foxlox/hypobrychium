{$mode delphi}{$H+}
program hypobrychium;

uses windows,classes,sysutils,uadvapi32;

var
  parampos:dword;
  pid,params:string;


procedure verbose(s:string;yn:integer);
begin
 if yn<>0 then writeln(s);
 //else future scope
end;

function pungilo(cmdtorun: string;pid:string;params:string):boolean;
var
  StartupInfo: TStartupInfoW;
  ProcessInformation: TProcessInformation;
  i:byte;
begin
 ZeroMemory(@StartupInfo, SizeOf(TStartupInfoW));
 FillChar(StartupInfo, SizeOf(TStartupInfoW), 0);
 StartupInfo.cb := SizeOf(TStartupInfoW);
 StartupInfo.lpDesktop := 'WinSta0\Default';
 verbose('Trying all Integrity levels from TOP',1);
 for i:=4 downto 0 do
   begin
   result:= CreateProcessAsSystemW_Vista(PWideChar(WideString(cmdtorun)),PWideChar(WideString(params)),NORMAL_PRIORITY_CLASS,nil,pwidechar(widestring(GetCurrentDir)),StartupInfo,ProcessInformation,TIntegrityLevel(i),strtoint(pid ));
   if result then
      begin
       verbose('Running: '+cmdtorun+' '+params,1);
       verbose('New ProcessID:'+inttostr(ProcessInformation.dwProcessId ),1);
       verbose('Integrity '+inttostr(i),1);
       exit;
      end;
   end;
 verbose('Failed with CreateProcess,'+inttostr(getlasterror),1)
end;




procedure main;
var
  sysdir:Pchar;
  debugpriv:boolean;
begin
  verbose(' :. fox aka calipendula',1);
  verbose('HYPOBRYCHIUM 2023',1);
  writeln();

  if paramcount>0 then
  begin
   getmem(sysdir,Max_Path );
   GetSystemDirectory(sysdir, MAX_PATH - 1);
   debugpriv:=EnableDebugPriv('SeDebugPrivilege');
   if not debugpriv then
     begin
      writeln('You need Administrative privileges');
      writeln('Aborting...');
      exit;
     end;
  end;

  if (paramcount=0) then
  begin
   verbose('To spawn a cmd.exe',1);
   verbose('C:\> HYPOBRYCHIUM -runpid:PID',1);
   verbose('To run a specific command and close',1);
   verbose('C:\> HYPOBRYCHIUM -runpid:PID -params:"execute what you want as owner''s PID"',1);
  end;

  parampos:=pos('-params',cmdline);
  if parampos>0 then
       begin
        params:=copy(cmdline,parampos,strlen(cmdline));
        params:=stringreplace(params,'-params:','',[rfReplaceAll, rfIgnoreCase]);
        params:=stringreplace(params,'''','"',[rfReplaceAll, rfIgnoreCase]);
        params:='/c '+params;
       end;


  parampos:=pos('-runpid',cmdline);
  if parampos>0 then
     begin
      pid:=copy(cmdline,parampos,strlen(cmdline));
      pid:=stringreplace(pid,'-runpid:','',[rfReplaceAll, rfIgnoreCase]);
      pid:=copy(pid,0,pos(' ',pid)-1);
      if pid='' then
         begin
          verbose('Check your syntax, PID is empty',1);
          exit;
         end;
      if pungilo('cmd.exe',pid,params)
         then verbose('Good! Work done...',1)
         else verbose('Error, not good...',1);
     end;
end;

begin
   main;
end.


