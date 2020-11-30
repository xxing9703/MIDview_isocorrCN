function varargout = gui_isocorr(varargin)
% GUI_ISOCORR MATLAB code for gui_isocorr.fig
%      GUI_ISOCORR, by itself, creates a new GUI_ISOCORR or raises the existing
%      singleton*.
%
%      H = GUI_ISOCORR returns the handle to a new GUI_ISOCORR or the handle to
%      the existing singleton*.
%
%      GUI_ISOCORR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ISOCORR.M with the given input arguments.
%
%      GUI_ISOCORR('Property','Value',...) creates a new GUI_ISOCORR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_isocorr_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_isocorr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_isocorr

% Last Modified by GUIDE v2.5 30-Nov-2020 13:58:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_isocorr_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_isocorr_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_isocorr is made visible.
function gui_isocorr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_isocorr (see VARARGIN)

% Choose default command line output for gui_isocorr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_isocorr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_isocorr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_C_Callback(hObject, eventdata, handles)
% hObject    handle to edit_C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_C as text
%        str2double(get(hObject,'String')) returns contents of edit_C as a double


% --- Executes during object creation, after setting all properties.
function edit_C_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_N_Callback(hObject, eventdata, handles)
% hObject    handle to edit_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_N as text
%        str2double(get(hObject,'String')) returns contents of edit_N as a double


% --- Executes during object creation, after setting all properties.
function edit_N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_load.
function bt_load_Callback(hObject, eventdata, handles)
% hObject    handle to bt_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [file, path]=uigetfile('*.csv;*.xlsx');
filename=fullfile(path,file);
 if isequal(file,0)
    disp('User selected Cancel');
 else
     set(handles.text_msg,'String','Please wait......','BackgroundColor','r'); drawnow();
     A=readtable(filename,'readvariablename',true); %8/16/2020
     A=A(1:length(find([A.medMz]>0)),:); %9/2/2020 cut empty rows in case user edited csv.
     handles.text_fname.String=filename;    

     start_col=str2num(handles.edit_startcol.String); %intensity start column
  
     sample_name=A.Properties.VariableNames(start_col:end)';
     grp_name=sample_name;
     % set grpName if autogrouping is checked: string before the last '_' of sample_name
     if handles.checkbox_autogrouping.Value
     for i=1:length(sample_name)
         C=strsplit(sample_name{i},'_');
         if length(C)>1
             grp_name{i,1}=sample_name{i}(1:length(sample_name{i})-length(C{end})-1);
         else
             grp_name{i,1}=sample_name{i};
         end
     end 
     end
     handles.text_nsample.String=num2str(length(sample_name));
     handles.text_ngroup.String=num2str(length(unique(grp_name)));
     
   % parse table data and store in meta  
     
     ID=unique(A.metaGroupId,'stable');  %unique metabolite IDs // changed to use metaGroupId 7/17/2020
     if length(ID)<=1         
         [~,~,ids]=unique(A.compoundId,'stable');  %if no metaGroupId, change to compoundID and add metaGroupId
         [A.metaGroupId]=ids;
         ID=unique(A.metaGroupId,'stable');
     end
     
   % read formula, extra C/N number
     for i=1:length(ID) %loop over metabolites        
        ids=find(A.metaGroupId==ID(i));    %7/17/2020
        A_sub=A(ids,:); %A_sub: data sheet for the selected metabolite ID 
        try  %8/16/2020  added warning message for incorrect formulas
            [~,~,tp]=formula2mass(A_sub.formula{1});
        catch
            msgbox(['check row#',num2str(ids(1)+1),' for errors in the formula name: ',A_sub.formula{1}],'Error detected!');
            return
        end
        C_num=tp(1);
        N_num=tp(2);
     %short table-->full table (C+1)(N+1), insert rows with zero signals
        lb=A_sub.isotopeLabel; %string analysis to get number of C/N label
        counts=zeros(length(lb),2);
         for j=1:length(lb)
             str=lb{j};
             [Clb,Nlb,errmsg]=str2CN(str);
             if errmsg==0
               counts(j,1)=Clb;
               counts(j,2)=Nlb; 
             else
               msgbox('erros in isotopeLabel detected');
               return
             end
        end
     v1=repmat(0:N_num,1,C_num+1);
     v2=reshape(repmat(0:C_num,N_num+1,1),1,(N_num+1)*(C_num+1));
     cn=[v1;v2]';
     cn=cn(:,[2,1]); %full list,iterate all C/N combinations
     dt=A_sub{:,start_col:end};
     fulldt=[]; idx_r=[]; idx_j=[];
     for j=1:size(cn,1)
       tp=find(ismember(counts,cn(j,:),'rows'));
       if isempty(tp)
          fulldt=[fulldt;zeros(1,size(dt,2))];
       else
          idx_r=[idx_r,tp];
          idx_j=[idx_j,j];
          fulldt=[fulldt;dt(tp,:)];
       end
     end
       [~,b]=sort(idx_r);
       reduced_idx=idx_j(b);
        
        meta(i).ID=ID(i);      
        meta(i).name=A_sub.compound{1};
        meta(i).formula=A_sub.formula{1};
        meta(i).mz=A_sub.medMz(1);
        meta(i).rt=A_sub.medRt(1);
        meta(i).C_num=C_num;
        meta(i).N_num=N_num; 
        meta(i).original_abs=fulldt;
        meta(i).original_pct=fulldt./sum(fulldt,1);
        meta(i).tic=sum(fulldt,1);
        meta(i).reduced_idx=reduced_idx;
        
     end
   %write to uitables  
     A=A(:,[10:11,1:9,12:end]);
     handles.uitable1.Data=table2cell(A);
     handles.uitable1.ColumnName=A.Properties.VariableNames;
     handles.uitable2.Data=[sample_name,grp_name];
     drawnow();
   %initialize
     handles.currentid=1;
     handles.checkbox1.Value=0;
     handles.bt_report.Enable='off';
     handles.checkbox1.Enable='off';
     handles.start_col=start_col;

     
   %pass variables  
     handles.A=A;
     handles.meta=meta;
     handles.grp_name=grp_name;
     guidata(hObject, handles);  
     
     %plot 1st one
     ev.Indices=[1,1];
     uitable1_CellSelectionCallback(hObject, ev, handles)
     
     set(handles.text_msg,'String','Ready','BackgroundColor','g'); drawnow();
     handles.bt_run.Enable='on';
 end

% --- Executes on button press in bt_run.
function bt_run_Callback(hObject, eventdata, handles)
% hObject    handle to bt_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text_msg,'String','Please wait...','BackgroundColor','r'); drawnow();
A=handles.A;
meta=handles.meta;
impurity_C=str2num(handles.edit_C.String);
impurity_N=str2num(handles.edit_N.String);
cat_abs=[];cat_pct=[];
for i=1:length(meta)
  
 [corr_abs,~,corr_pct]=isocorr_CN(meta(i).original_abs,meta(i).C_num,meta(i).N_num,impurity_C,impurity_N);
 idx=meta(i).reduced_idx;  
 meta(i).corr_abs=corr_abs;
 meta(i).corr_pct=corr_pct;
 meta(i).corr_abs_short=corr_abs(idx,:); %shottable for output
 meta(i).corr_pct_short=corr_pct(idx,:); %shorttable for output
 meta(i).corr_tic=sum(meta(i).corr_abs,1);
  
 cat_abs=[cat_abs;corr_abs(idx,:)];  %concatenate for csv output
 cat_pct=[cat_pct;corr_pct(idx,:)];  
end

start_col=15;
A_part1=A(:,1:start_col-1);
A_part2=A(:,start_col:end);

A_part2{:,:}=cat_abs;
A_corr_abs=[A_part1,A_part2];

A_part2{:,:}=cat_pct;
A_corr_pct=[A_part1,A_part2];

% make 3rd table as total ion/////////////
for i=1:length(meta)
  A_corr_total{i,1}=meta(i).ID;
  A_corr_total{i,2}=meta(i).name;
  A_corr_total{i,3}=meta(i).formula;
  for j=1:length(meta(i).tic)
  A_corr_total{i,3+j}=meta(i).tic(j);
  end
end
A_corr_total=cell2table(A_corr_total);
A_corr_total.Properties.VariableNames=[{'ID','Name','formula'},A.Properties.VariableNames(start_col:end)];
% end 3rd table  ////////////////////////

%update uitable1 according to popupmenu (relative or absolute)
% B=handles.uitable1.Data;
% if handles.popup1.Value==2
%     B(:,start_col:end)=num2cell(cat_abs);
% else
%     B(:,start_col:end)=num2cell(cat_pct);
% end
% handles.uitable1.Data=B;

%save to ####_cor.csv
fname=handles.text_fname.String;
[filepath,name,~] = fileparts(fname);
fname_S=fullfile(filepath,[name,'_cor','.xlsx']); %fname_S: filename for save
writetable(A_corr_pct,fname_S,'sheet','enrichment');
writetable(A_corr_abs,fname_S,'sheet','absolte');
writetable(A_corr_total,fname_S,'sheet','total ion');

handles.meta=meta;
guidata(hObject, handles);  
set(handles.text_msg,'String','Ready','BackgroundColor','g'); drawnow();
msgbox({'Successful!!','', 'Check out the export file:',['"',name,'_cor','.xlsx','"']},'About');
handles.checkbox1.Enable='on';
handles.checkbox1.Value=1;
handles.checkbox1.ForegroundColor='b';
handles.checkbox1.String='after correction';

handles.bt_report.Enable='on';

%update
ev.Indices=[handles.currentid,1];
uitable1_CellSelectionCallback(hObject, ev, handles)

% --- Executes on button press in bt_save.
function bt_save_Callback(hObject, eventdata, handles)
% hObject    handle to bt_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popup1.
function popup1_Callback(hObject, eventdata, handles)
% hObject    handle to popup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup1
ev.Indices=[handles.currentid,1];
uitable1_CellSelectionCallback(hObject, ev, handles)

% --- Executes during object creation, after setting all properties.
function popup1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_report.
function bt_report_Callback(hObject, eventdata, handles)
% hObject    handle to bt_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p1=handles.popup1.Value;
p2=handles.popup2.Value;
p3=handles.checkbox1.Value;
if p1==1&&p3==0
    fieldname='original_pct';    
elseif p1==2&&p3==0
     fieldname='original_abs';
elseif p1==1&&p3==1
     fieldname='corr_pct';
elseif p1==2&&p3==1
     fieldname='corr_abs';
end 
dim=[];

if p2==1
    default_pathname=[datestr(now,'yyyy-mm-dd'),'_',fieldname,'_13C'];
else
    default_pathname=[datestr(now,'yyyy-mm-dd'),'_',fieldname,'_15N'];
end
prompt = {'Enter folder name to store output figures','Enter # of row plots per page:','Enter # of Column plots per page:'};
answer = inputdlg(prompt,'Input',[1,45],{default_pathname,'4','4'});

if ~isempty(answer)
    dim=[str2num(answer{2}),str2num(answer{3})];
 if length(dim)==2
    mkdir(answer{1});
    path=fullfile(pwd,answer{1});
    plot2bar(handles.meta,fieldname,p2,handles.grp_name,dim,path);
 end
end

% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
dt=handles.uitable1.Data;
id=eventdata.Indices(1);
ID=dt{id,4};
meta=handles.meta;
ID=find([meta.ID]==ID);
grp_name=handles.grp_name;

p1=handles.popup1.Value;
p2=handles.popup2.Value;
p3=handles.checkbox1.Value;
if p1==1&& p3==0
    mydt=meta(ID).original_pct;
elseif p1==2&&p3==0
    mydt=meta(ID).original_abs;
elseif p1==1&&p3==1
    mydt=meta(ID).corr_pct;
elseif p1==2&&p3==1
    mydt=meta(ID).corr_abs;
end 
[Conly,Nonly,total]=sumCN(mydt,meta(ID).C_num,meta(ID).N_num);
if p2==1
    plot1_bar(handles.axes1,Conly,grp_name,1)
else
    plot1_bar(handles.axes1,Nonly,grp_name,1)
end
title(handles.axes1,[meta(ID).name,' (',meta(ID).formula,')'])
handles.currentid=id;
guidata(hObject, handles);

 


% --- Executes on selection change in popup2.
function popup2_Callback(hObject, eventdata, handles)
% hObject    handle to popup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup2

ev.Indices=[handles.currentid,1];
uitable1_CellSelectionCallback(hObject, ev, handles)

% --- Executes during object creation, after setting all properties.
function popup2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_apply.
function bt_apply_Callback(hObject, eventdata, handles)
% hObject    handle to bt_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dt=handles.uitable2.Data;
grp_name=dt(:,2);
handles.grp_name=grp_name;
handles.text_ngroup.String=num2str(length(unique(grp_name)));

guidata(hObject, handles);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
if handles.checkbox1.Value==0   
    handles.checkbox1.ForegroundColor='r';
    handles.checkbox1.String='before correction';
else    
    handles.checkbox1.ForegroundColor='b';
    handles.checkbox1.String='after correction';
end
guidata(hObject, handles);
ev.Indices=[handles.currentid,1];
uitable1_CellSelectionCallback(hObject, ev, handles)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure('NumberTitle', 'off','name','legend color scheme')
imshow('legend.png');


% --- Executes on button press in checkbox_autogrouping.
function checkbox_autogrouping_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_autogrouping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_autogrouping
 sample_name=handles.A.Properties.VariableNames(handles.start_col:end)';
     grp_name=sample_name;
     % set grpName if autogrouping is checked: string before the last '_' of sample_name
     if handles.checkbox_autogrouping.Value
     for i=1:length(sample_name)
         C=strsplit(sample_name{i},'_');
         if length(C)>1
             grp_name{i,1}=sample_name{i}(1:length(sample_name{i})-length(C{end})-1);
         else
             grp_name{i,1}=sample_name{i};
         end
     end 
     end
     handles.text_nsample.String=num2str(length(sample_name));
     handles.text_ngroup.String=num2str(length(unique(grp_name)));
     handles.grp_name=grp_name;
     handles.uitable2.Data=[sample_name,grp_name];
     guidata(hObject, handles);



function edit_startcol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_startcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_startcol as text
%        str2double(get(hObject,'String')) returns contents of edit_startcol as a double


% --- Executes during object creation, after setting all properties.
function edit_startcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_startcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
