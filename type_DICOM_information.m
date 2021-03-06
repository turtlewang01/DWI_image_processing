function [num_image,num_slice] = type_DICOM_information
d = dialog('Units','normalized','Position',[0.45 0.45 0.25 0.20],'Name','File information:');
txtimage = uicontrol('Parent',d,...
    'Style','text',...
    'Units','normalized',...
    'FontSize',10,...
    'HorizontalAlignment','left',...
    'Position',[0.10 0.7 0.3 0.15],...
    'String','Number of images:');

editbox_num_image = uicontrol('Parent',d,...
    'Style','edit',...
    'Units','normalized',...
    'FontSize',10,...
     'String','0',...
    'Position',[0.1 0.5 0.25 0.15],...     
    'Callback',@editboximagenum_callback);

txtslice = uicontrol('Parent',d,...
    'Style','text',...
    'Units','normalized',...
    'FontSize',10,...
    'HorizontalAlignment','left',...
    'Position',[0.6 0.7 0.3 0.15],...
    'String','Number of slice:');

editbox_slice = uicontrol('Parent',d,...
    'Style','edit',...
    'Units','normalized',...
    'FontSize',10,...
    'Position',[0.6 0.5 0.25 0.15],...
    'Max',1,...
    'String','0',...
    'Callback',@editboxslice_callback);

btn = uicontrol('Parent',d,...
           'Units','normalized',...
           'Position',[0.33 0.15 0.3 0.2],...
           'String','Next',...
           'FontSize',10,...
           'Callback','delete(gcf)');
uiwait(d)
    function editboximagenum_callback(editbox_num_image, callbackdata)        
        num_image = str2num(editbox_num_image.String);        
    end

function editboxslice_callback(editbox_slice, callbackdata)        
        num_slice = str2num(editbox_slice.String);
    end
end



