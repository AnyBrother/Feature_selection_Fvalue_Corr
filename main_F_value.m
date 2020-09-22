clc;
clear;
warning off;

%% excel数据存为.mat的预处理, 读取所有上市企业数据
path = ".\data\";
data_file_name_all = '全部数据读取_模板.xlsx';
sheet_name_all = {'标准'};  % Excel文件的Sheet名称
data_name_all = {'all_list_std'};  % Excel文件的Sheet名称的.mat文件名称标记
index_start = 19;  % 数值型指标开始的列数
type_all = 'all_list';  % 如果25000<样本数<50000,选用'all_list'
for i=1:length(data_name_all)
    sheet_name_temp = sheet_name_all{i};
    data_name_temp = data_name_all{i};
    excel_data_preprocess(path, data_file_name_all, sheet_name_temp, data_name_temp, index_start, type_all);
end

%% 上市企业确定一定剔除或一定保留的指标
% 保留的指标
path = ".\data\";
feature_del_remain_file_name = '人工定义保留或剔除的指标_模板.xlsx';
[~,indicators_name_add_old] = xlsread(path+feature_del_remain_file_name ,'保留');
[row,~] = size(indicators_name_add_old);
indicators_name_add = {};
for i=1:row
    indicators_name_add{1,i} = indicators_name_add_old{i,1};
end
% 剔除的指标
[~,indicators_name_del_old] = xlsread(path+feature_del_remain_file_name ,'剔除');
[row2,~] = size(indicators_name_del_old);
indicators_name_del = {};
for i=1:row2
    indicators_name_del{1,i} = indicators_name_del_old{i,1};
end
save (path+'IndicatorAddDel_for_FirstFeaSelection_list.mat', 'indicators_name_add','indicators_name_del');

%% 载入.mat数据
dataset_name = {'all_list_std_data_save'};
temp_data_name = dataset_name{1}(1:8);  % 取dataset_num前8个字符作为标识符
load_var_data_1 = string(temp_data_name)+'_std_data_1';  % 标识性数据+指标标准化后的数据及违约状态(前25000个)
load_var_data_2 = string(temp_data_name)+'_std_data_2';  % 标识性数据+指标标准化后的数据及违约状态(25000之后的)
load_var_x_y_1 = string(temp_data_name)+'_std_x_y_1';  % 指标标准化后的数据及违约状态(前25000个)
load_var_x_y_2 = string(temp_data_name)+'_std_x_y_2';  % 指标标准化后的数据及违约状态(25000之后的)
load_var_x_1 = string(temp_data_name)+'_std_x_1';  % 指标标准化后的数据(前25000个)
load_var_x_2 = string(temp_data_name)+'_std_x_2';  % 指标标准化后的数据(25000之后的)
load_var_y_1 = string(temp_data_name)+'_std_y_1';  % 违约状态(前25000个)
load_var_y_2 = string(temp_data_name)+'_std_y_2';  % 违约状态(25000之后的)
load_var_identity_1 = string(temp_data_name)+'_std_identity_1';  % 标识性指标(证券代码等)(前25000个)
load_var_identity_2 = string(temp_data_name)+'_std_identity_2';  % 标识性指标(证券代码等)(25000之后的)
load_var_name = string(temp_data_name)+'_std_indicator_names';  % 指标名称(资产负债率等)
load_var_attr = string(temp_data_name)+'_std_indicator_attrs';  % 指标属性(0:continuous; 1:discrete; 2:标识性)
load ('.\data\'+string(dataset_name{1})+'.mat',load_var_data_1,load_var_data_2, load_var_x_y_1,load_var_x_y_2,...
    load_var_x_1, load_var_x_2, load_var_y_1, load_var_y_2, load_var_identity_1, load_var_identity_2, load_var_name,load_var_attr);  % 载入对应数据
load ('.\data\IndicatorAddDel_for_FirstFeaSelection_list.mat','indicators_name_add','indicators_name_del');

%% 整合数据
% 输出excel整合
eval(['load_var_identity = ['+load_var_identity_1+';'+load_var_identity_2+'];']);  % 标识性指标.
eval(['load_var_y = ['+load_var_y_1+'(3:end);'+load_var_y_2+'];']);  % 违约状态指标.
data_identity_y = [load_var_identity,num2cell(load_var_y)];   % 标识性指标(证券代码等)+违约状态

eval(['load_var_data = ['+load_var_data_1+';'+load_var_data_2+'];']);  % data_cell的合并.
eval(['all_indicator_names='+load_var_name+';']);
eval(['all_identity_names=load_var_data(2, 1:(index_start-1));']);
out_col_names = [all_identity_names, all_indicator_names];

% 进行指标遴选的数据整合
eval(['data_x_y = ['+load_var_x_y_1+';'+load_var_x_y_2+'];']);  % 输入的数据,都是double类,最后一列是标签.
eval(['feas_name = '+load_var_name+';']); % 数据对应的列名,是cell类.
fea_remain = indicators_name_add; % 要保留的指标
fea_del = indicators_name_del; % 要删除的指标
threshold = 0.7;  % 相关系数临界点
criteria_num=[49, 105, 44, 23, 39, 8, 24, 3, 2, 53, 1];  % 每个准则层个数,分准则层指标遴选
mark = temp_data_name;

%% F值相关系数指标遴选
[remained_data_corr_del_add,remained_name_corr_del_add,deleted_data_coor_del_add,deleted_name_coor_del_add] = feature_selection_corr(data_x_y, feas_name, threshold, criteria_num, fea_remain, fea_del, mark);
eval(['[~, fs_idx_temp] = ismember(remained_name_corr_del_add,'+load_var_name+');']);
eval(['attr_after_first_FeaSel = '+load_var_attr+'(fs_idx_temp(1:end-1));']);  % 第一次指标遴选后的连续离散变量标记
eval(['[fs_first_in, ~] = ismember('+load_var_name+',remained_name_corr_del_add);']);

%% 方差膨胀因子VIF和条件数the conditional number计算检验
R = corrcoef(remained_data_corr_del_add(:,1:end-1));
VIF = max(diag(inv(R))); % variance inflation factor.VIF<5即视为无共线性; 5<=VIF<=10,,中等程度共线性;VIF>10,严重共线性.
cond_num = cond(R); % conditional number, cond<=100即视为无共线性;cond>100即视为严重共线性.
corr_test_out = [ {'VIF方差膨胀因子(<5)','Cond_num条件数(<100)'}; num2cell([VIF, cond_num])];  % 

%% 保存excel结果,便于验证
identity_x_y_after_first_FeaSel = [data_identity_y(1:end, 1:end-1), num2cell(remained_data_corr_del_add)]; % 第1次指标遴选后,训练样本--标识性指标+训练样本+真实违约状态
out_col_names = [all_identity_names, remained_name_corr_del_add];
t=now;
time_out = [datestr(t,'yyyy.mm.dd') datestr(t,'.hh：mm.')];
xlswrite('.\data\data_out\'+string(temp_data_name)+'.'+string(time_out)+'F值相关系数指标遴选结果.xlsx',[out_col_names;identity_x_y_after_first_FeaSel],'第1次指标遴选后的样本') % 第1次指标遴选后的样本数据
xlswrite('.\data\data_out\'+string(temp_data_name)+'.'+string(time_out)+'F值相关系数指标遴选结果.xlsx',corr_test_out,'第1次指标遴选后的相关性检验') % 第1次指标遴选后的相关性检验
