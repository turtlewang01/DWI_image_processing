function nii_information = type_nii_information
nii_information.bval=0;
nii_information.name='Zhang';
d = dialog('Units','normalized',...
        'Position',[0.45 0.45 0.2 0.2],...
        'Name','File information:');
txtbval = uicontrol('Parent',d,...
    'Style','text',...
    'FontSize',10,...
    'Units','normalized',...
    'Position',[0.1 0.8 0.2 0.1],...
    'String','b_value');

editbox_bval = uicontrol('Parent',d,...
    'Style','edit',...
    'Units','normalized',...
    'FontSize',10,...
    'Position',[0.1 0.3 0.2 0.4],...
    'Max',2,...
    'String','0',...
    'Callback',@editboxbval_callback);

txtname = uicontrol('Parent',d,...
    'Style','text',...
    'Units','normalized',...
    'FontSize',10,...
    'Position',[0.6 0.8 0.2 0.1],...
    'String','Name');

editbox_name = uicontrol('Parent',d,...
    'Style','edit',...
    'Units','normalized',...
    'FontSize',10,...
    'Position',[0.6 0.5 0.25 0.15],...
    'Max',1,...
    'String','0',...
    'Callback',@editboxname_callback);

btn = uicontrol('Parent',d,...
            'Units','normalized',...
           'Position',[0.4 0.15 0.25 0.20],...
           'FontSize',10,...
           'String','Next',...
           'Callback','delete(gcf)');
       uiwait(d)
    function editboxbval_callback(editbox_bval, callbackdata)        
        temp = str2num(editbox_bval.String);
        nii_information.bval=temp';
    end

    function editboxname_callback(editbox_name, callbackdata)
        patient_name = editbox_name.String;
        nii_information.name=patient_name;
    end
end



