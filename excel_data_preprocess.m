function excel_data_preprocess(path, data_file_name, sheet_name, data_name, index_start, type)
%{
该程序目的是进行excel数据读取划分,并生成.mat格式文件.
Input:
    path: 路径名str
    data_file_name: 文件名str
    sheet_name: 读取子表名称str
    data_name: 想要的输出数据标识str
    index_start: 带入模型指标的初始列数double
    type: 区分数据文件的类型str,避免存储的mat文件过大.
Output:
    [num2str(data_name),'_data_save.mat']的.mat文件
%}
%% 读取excel数据文件,对应sheet中的数据(第1行是指标类型,第2行是指标名称,最后1列是违约状态)
[data_with_indicators,indicators_name] = xlsread(path + data_file_name, sheet_name);
indicators_attr_list = data_with_indicators(1, :);  % 指标性质(0:continuous; 1:discrete; 2:标识性)
indicators_name_list = indicators_name(1, :);  % 所有指标名称(字符串构成的向量)
[~, col] = size(data_with_indicators);  % 确定列数(所有指标个数)
data_with_indicators_cell = num2cell(data_with_indicators);  % 将数值矩阵转化为cell
data_full = [num2cell(indicators_attr_list);indicators_name];  % 定义全部数据的cell,便于输出excel
for i=1:col
    if isempty(data_full{3,i})
        [data_full{3:end,i}] = data_with_indicators_cell{3:end,i};  % 将字符矩阵cell第3行空的列,填补为对应指标数值
    end
end

%% 将所有double转换为char,或在MATLAB——主页——预设——常规——MAT文件,选可存储大文件.
% TCInd = cellfun(@isnumeric, indicators_name_ori_full);
% indicators_name_ori_full(TCInd)= cellfun(@num2str,indicators_name_ori_full(TCInd),'UniformOutput',false);
switch (type)
    case 'all_list'
        % 保存为.mat格式的数据
        cutpoint = 25000;
        all_data1 = [num2str(data_name),'_data_1'];
        all_data2 = [num2str(data_name),'_data_2'];
        % all_data = data_full;
        eval([all_data1,'=data_full(1:cutpoint,:);']);
        eval([all_data2,'=data_full(cutpoint+1:end,:);']);
        % 只保存标识性数据 
        data_identity_1 = [num2str(data_name),'_identity_1'];
        data_identity_2 = [num2str(data_name),'_identity_2'];
        eval([data_identity_1,'=data_full(3:3+cutpoint,1:index_start-1);']);
        eval([data_identity_2,'=data_full(3+cutpoint+1:end,1:index_start-1);']);
        % 只保存指标数据x_y
        indicator_num_data_x_y_1 = [num2str(data_name),'_x_y_1'];
        indicator_num_data_x_y_2 = [num2str(data_name),'_x_y_2'];
        eval([indicator_num_data_x_y_1,'=data_with_indicators(3:3+cutpoint,index_start:end);']);
        eval([indicator_num_data_x_y_2,'=data_with_indicators(3+cutpoint+1:end,index_start:end);']);
        % 只保存指标数据x
        indicator_num_data_x1 = [num2str(data_name),'_x_1'];
        indicator_num_data_x2 = [num2str(data_name),'_x_2'];
        eval([indicator_num_data_x1,'=data_with_indicators(3:3+cutpoint,index_start:end-1);']);
        eval([indicator_num_data_x2,'=data_with_indicators(3+cutpoint+1:end,index_start:end-1);']);
        % 只保存指标数据y
        indicator_num_data_y1 = [num2str(data_name),'_y_1'];
        indicator_num_data_y2 = [num2str(data_name),'_y_2'];
        eval([indicator_num_data_y1,'=data_with_indicators(1:cutpoint,end);']);
        eval([indicator_num_data_y2,'=data_with_indicators(cutpoint+1:end,end);']);
        % 只保存需要的指标名称
        indicator_names = [num2str(data_name),'_indicator_names'];
        eval([indicator_names,'=cellstr(indicators_name_list(index_start:end));']);
        % 只保存指标名称对应的的指标属性
        indicator_attrs = [num2str(data_name),'_indicator_attrs'];
        eval([indicator_attrs,'=indicators_attr_list(index_start:end);']);
        % 存为.mat数据文件
        mat_name = [num2str(data_name),'_data_save.mat'];
        save(path+mat_name, all_data1, all_data2, data_identity_1, data_identity_2, ...
            indicator_num_data_x_y_1, indicator_num_data_x_y_2, indicator_num_data_x1, ...
            indicator_num_data_x2, indicator_num_data_y1, indicator_num_data_y2, ...
            indicator_names, indicator_attrs);
    case {'t_m','all_SME'}
        % 保存为.mat格式的数据
        all_data = [num2str(data_name),'_data'];
        % all_data = data_full;
        eval([all_data,'=data_full;']);
        % 只保存标识性数据 
        data_identity = [num2str(data_name),'_identity'];
        eval([data_identity,'=data_full(3:end,1:index_start-1);']);
        % 只保存指标数据x_y
        % data_x_y = data_with_indicators_ori(1:end,index_start:end);
        indicator_num_data_x_y = [num2str(data_name),'_x_y'];
        eval([indicator_num_data_x_y,'=data_with_indicators(3:end,index_start:end);']);
        % 只保存指标数据x
        indicator_num_data_x = [num2str(data_name),'_x'];
        eval([indicator_num_data_x,'=data_with_indicators(3:end,index_start:end-1);']);
        % 只保存指标数据y
        indicator_num_data_y = [num2str(data_name),'_y'];
        eval([indicator_num_data_y,'=data_with_indicators(3:end,end);']);
        % 只保存需要的指标名称
        % indicator_names = cellstr(indicators_name_ori_list(index_start:end));
        indicator_names = [num2str(data_name),'_indicator_names'];
        eval([indicator_names,'=cellstr(indicators_name_list(index_start:end));']);
        % 只保存指标名称对应的的指标属性
        indicator_attrs = [num2str(data_name),'_indicator_attrs'];
        eval([indicator_attrs,'=indicators_attr_list(index_start:end);']);
        % 存为.mat数据文件
        mat_name = [num2str(data_name),'_data_save.mat'];
        save(path+mat_name, all_data, data_identity, indicator_num_data_x_y, ...
            indicator_num_data_x, indicator_num_data_y, indicator_names, indicator_attrs);
    case 'all_XSB'
        % 保存为.mat格式的数据
        cutpoint = 25000;
        all_data1 = [num2str(data_name),'_data_1'];
        all_data2 = [num2str(data_name),'_data_2'];
        % all_data = data_full;
        eval([all_data1,'=data_full(1:cutpoint,:);']);
        eval([all_data2,'=data_full(cutpoint+1:end,:);']);
        % 只保存标识性数据 
        data_identity_1 = [num2str(data_name),'_identity_1'];
        data_identity_2 = [num2str(data_name),'_identity_2'];
        eval([data_identity_1,'=data_full(3:3+cutpoint,1:index_start-1);']);
        eval([data_identity_2,'=data_full(3+cutpoint+1:end,1:index_start-1);']);
        % 只保存指标数据x_y
        indicator_num_data_x_y_1 = [num2str(data_name),'_x_y_1'];
        indicator_num_data_x_y_2 = [num2str(data_name),'_x_y_2'];
        eval([indicator_num_data_x_y_1,'=data_with_indicators(3:3+cutpoint,index_start:end);']);
        eval([indicator_num_data_x_y_2,'=data_with_indicators(3+cutpoint+1:end,index_start:end);']);
        % 只保存指标数据x
        indicator_num_data_x1 = [num2str(data_name),'_x_1'];
        indicator_num_data_x2 = [num2str(data_name),'_x_2'];
        eval([indicator_num_data_x1,'=data_with_indicators(3:3+cutpoint,index_start:end-1);']);
        eval([indicator_num_data_x2,'=data_with_indicators(3+cutpoint+1:end,index_start:end-1);']);
        % 只保存指标数据y
        indicator_num_data_y1 = [num2str(data_name),'_y_1'];
        indicator_num_data_y2 = [num2str(data_name),'_y_2'];
        eval([indicator_num_data_y1,'=data_with_indicators(1:cutpoint,end);']);
        eval([indicator_num_data_y2,'=data_with_indicators(cutpoint+1:end,end);']);
        % 只保存需要的指标名称
        indicator_names = [num2str(data_name),'_indicator_names'];
        eval([indicator_names,'=cellstr(indicators_name_list(index_start:end));']);
        % 只保存指标名称对应的的指标属性
        indicator_attrs = [num2str(data_name),'_indicator_attrs'];
        eval([indicator_attrs,'=indicators_attr_list(index_start:end);']);
        % 存为.mat数据文件
        mat_name = [num2str(data_name),'_data_save.mat'];
        save(path+mat_name, all_data1, all_data2, data_identity_1, data_identity_2, ...
            indicator_num_data_x_y_1, indicator_num_data_x_y_2, indicator_num_data_x1, ...
            indicator_num_data_x2, indicator_num_data_y1, indicator_num_data_y2, ...
            indicator_names, indicator_attrs);
    otherwise
        fprintf('\n Warning: Invalid Type Name!!!\n');
end

