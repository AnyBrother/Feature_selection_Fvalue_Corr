function excel_data_preprocess(path, data_file_name, sheet_name, data_name, index_start, type)
%{
�ó���Ŀ���ǽ���excel���ݶ�ȡ����,������.mat��ʽ�ļ�.
Input:
    path: ·����str
    data_file_name: �ļ���str
    sheet_name: ��ȡ�ӱ�����str
    data_name: ��Ҫ��������ݱ�ʶstr
    index_start: ����ģ��ָ��ĳ�ʼ����double
    type: ���������ļ�������str,����洢��mat�ļ�����.
Output:
    [num2str(data_name),'_data_save.mat']��.mat�ļ�
%}
%% ��ȡexcel�����ļ�,��Ӧsheet�е�����(��1����ָ������,��2����ָ������,���1����ΥԼ״̬)
[data_with_indicators,indicators_name] = xlsread(path + data_file_name, sheet_name);
indicators_attr_list = data_with_indicators(1, :);  % ָ������(0:continuous; 1:discrete; 2:��ʶ��)
indicators_name_list = indicators_name(1, :);  % ����ָ������(�ַ������ɵ�����)
[~, col] = size(data_with_indicators);  % ȷ������(����ָ�����)
data_with_indicators_cell = num2cell(data_with_indicators);  % ����ֵ����ת��Ϊcell
data_full = [num2cell(indicators_attr_list);indicators_name];  % ����ȫ�����ݵ�cell,�������excel
for i=1:col
    if isempty(data_full{3,i})
        [data_full{3:end,i}] = data_with_indicators_cell{3:end,i};  % ���ַ�����cell��3�пյ���,�Ϊ��Ӧָ����ֵ
    end
end

%% ������doubleת��Ϊchar,����MATLAB������ҳ����Ԥ�衪�����桪��MAT�ļ�,ѡ�ɴ洢���ļ�.
% TCInd = cellfun(@isnumeric, indicators_name_ori_full);
% indicators_name_ori_full(TCInd)= cellfun(@num2str,indicators_name_ori_full(TCInd),'UniformOutput',false);
switch (type)
    case 'all_list'
        % ����Ϊ.mat��ʽ������
        cutpoint = 25000;
        all_data1 = [num2str(data_name),'_data_1'];
        all_data2 = [num2str(data_name),'_data_2'];
        % all_data = data_full;
        eval([all_data1,'=data_full(1:cutpoint,:);']);
        eval([all_data2,'=data_full(cutpoint+1:end,:);']);
        % ֻ�����ʶ������ 
        data_identity_1 = [num2str(data_name),'_identity_1'];
        data_identity_2 = [num2str(data_name),'_identity_2'];
        eval([data_identity_1,'=data_full(3:3+cutpoint,1:index_start-1);']);
        eval([data_identity_2,'=data_full(3+cutpoint+1:end,1:index_start-1);']);
        % ֻ����ָ������x_y
        indicator_num_data_x_y_1 = [num2str(data_name),'_x_y_1'];
        indicator_num_data_x_y_2 = [num2str(data_name),'_x_y_2'];
        eval([indicator_num_data_x_y_1,'=data_with_indicators(3:3+cutpoint,index_start:end);']);
        eval([indicator_num_data_x_y_2,'=data_with_indicators(3+cutpoint+1:end,index_start:end);']);
        % ֻ����ָ������x
        indicator_num_data_x1 = [num2str(data_name),'_x_1'];
        indicator_num_data_x2 = [num2str(data_name),'_x_2'];
        eval([indicator_num_data_x1,'=data_with_indicators(3:3+cutpoint,index_start:end-1);']);
        eval([indicator_num_data_x2,'=data_with_indicators(3+cutpoint+1:end,index_start:end-1);']);
        % ֻ����ָ������y
        indicator_num_data_y1 = [num2str(data_name),'_y_1'];
        indicator_num_data_y2 = [num2str(data_name),'_y_2'];
        eval([indicator_num_data_y1,'=data_with_indicators(1:cutpoint,end);']);
        eval([indicator_num_data_y2,'=data_with_indicators(cutpoint+1:end,end);']);
        % ֻ������Ҫ��ָ������
        indicator_names = [num2str(data_name),'_indicator_names'];
        eval([indicator_names,'=cellstr(indicators_name_list(index_start:end));']);
        % ֻ����ָ�����ƶ�Ӧ�ĵ�ָ������
        indicator_attrs = [num2str(data_name),'_indicator_attrs'];
        eval([indicator_attrs,'=indicators_attr_list(index_start:end);']);
        % ��Ϊ.mat�����ļ�
        mat_name = [num2str(data_name),'_data_save.mat'];
        save(path+mat_name, all_data1, all_data2, data_identity_1, data_identity_2, ...
            indicator_num_data_x_y_1, indicator_num_data_x_y_2, indicator_num_data_x1, ...
            indicator_num_data_x2, indicator_num_data_y1, indicator_num_data_y2, ...
            indicator_names, indicator_attrs);
    case {'t_m','all_SME'}
        % ����Ϊ.mat��ʽ������
        all_data = [num2str(data_name),'_data'];
        % all_data = data_full;
        eval([all_data,'=data_full;']);
        % ֻ�����ʶ������ 
        data_identity = [num2str(data_name),'_identity'];
        eval([data_identity,'=data_full(3:end,1:index_start-1);']);
        % ֻ����ָ������x_y
        % data_x_y = data_with_indicators_ori(1:end,index_start:end);
        indicator_num_data_x_y = [num2str(data_name),'_x_y'];
        eval([indicator_num_data_x_y,'=data_with_indicators(3:end,index_start:end);']);
        % ֻ����ָ������x
        indicator_num_data_x = [num2str(data_name),'_x'];
        eval([indicator_num_data_x,'=data_with_indicators(3:end,index_start:end-1);']);
        % ֻ����ָ������y
        indicator_num_data_y = [num2str(data_name),'_y'];
        eval([indicator_num_data_y,'=data_with_indicators(3:end,end);']);
        % ֻ������Ҫ��ָ������
        % indicator_names = cellstr(indicators_name_ori_list(index_start:end));
        indicator_names = [num2str(data_name),'_indicator_names'];
        eval([indicator_names,'=cellstr(indicators_name_list(index_start:end));']);
        % ֻ����ָ�����ƶ�Ӧ�ĵ�ָ������
        indicator_attrs = [num2str(data_name),'_indicator_attrs'];
        eval([indicator_attrs,'=indicators_attr_list(index_start:end);']);
        % ��Ϊ.mat�����ļ�
        mat_name = [num2str(data_name),'_data_save.mat'];
        save(path+mat_name, all_data, data_identity, indicator_num_data_x_y, ...
            indicator_num_data_x, indicator_num_data_y, indicator_names, indicator_attrs);
    case 'all_XSB'
        % ����Ϊ.mat��ʽ������
        cutpoint = 25000;
        all_data1 = [num2str(data_name),'_data_1'];
        all_data2 = [num2str(data_name),'_data_2'];
        % all_data = data_full;
        eval([all_data1,'=data_full(1:cutpoint,:);']);
        eval([all_data2,'=data_full(cutpoint+1:end,:);']);
        % ֻ�����ʶ������ 
        data_identity_1 = [num2str(data_name),'_identity_1'];
        data_identity_2 = [num2str(data_name),'_identity_2'];
        eval([data_identity_1,'=data_full(3:3+cutpoint,1:index_start-1);']);
        eval([data_identity_2,'=data_full(3+cutpoint+1:end,1:index_start-1);']);
        % ֻ����ָ������x_y
        indicator_num_data_x_y_1 = [num2str(data_name),'_x_y_1'];
        indicator_num_data_x_y_2 = [num2str(data_name),'_x_y_2'];
        eval([indicator_num_data_x_y_1,'=data_with_indicators(3:3+cutpoint,index_start:end);']);
        eval([indicator_num_data_x_y_2,'=data_with_indicators(3+cutpoint+1:end,index_start:end);']);
        % ֻ����ָ������x
        indicator_num_data_x1 = [num2str(data_name),'_x_1'];
        indicator_num_data_x2 = [num2str(data_name),'_x_2'];
        eval([indicator_num_data_x1,'=data_with_indicators(3:3+cutpoint,index_start:end-1);']);
        eval([indicator_num_data_x2,'=data_with_indicators(3+cutpoint+1:end,index_start:end-1);']);
        % ֻ����ָ������y
        indicator_num_data_y1 = [num2str(data_name),'_y_1'];
        indicator_num_data_y2 = [num2str(data_name),'_y_2'];
        eval([indicator_num_data_y1,'=data_with_indicators(1:cutpoint,end);']);
        eval([indicator_num_data_y2,'=data_with_indicators(cutpoint+1:end,end);']);
        % ֻ������Ҫ��ָ������
        indicator_names = [num2str(data_name),'_indicator_names'];
        eval([indicator_names,'=cellstr(indicators_name_list(index_start:end));']);
        % ֻ����ָ�����ƶ�Ӧ�ĵ�ָ������
        indicator_attrs = [num2str(data_name),'_indicator_attrs'];
        eval([indicator_attrs,'=indicators_attr_list(index_start:end);']);
        % ��Ϊ.mat�����ļ�
        mat_name = [num2str(data_name),'_data_save.mat'];
        save(path+mat_name, all_data1, all_data2, data_identity_1, data_identity_2, ...
            indicator_num_data_x_y_1, indicator_num_data_x_y_2, indicator_num_data_x1, ...
            indicator_num_data_x2, indicator_num_data_y1, indicator_num_data_y2, ...
            indicator_names, indicator_attrs);
    otherwise
        fprintf('\n Warning: Invalid Type Name!!!\n');
end

