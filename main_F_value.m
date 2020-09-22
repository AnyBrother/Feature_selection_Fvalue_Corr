clc;
clear;
warning off;

%% excel���ݴ�Ϊ.mat��Ԥ����, ��ȡ����������ҵ����
path = ".\data\";
data_file_name_all = 'ȫ�����ݶ�ȡ_ģ��.xlsx';
sheet_name_all = {'��׼'};  % Excel�ļ���Sheet����
data_name_all = {'all_list_std'};  % Excel�ļ���Sheet���Ƶ�.mat�ļ����Ʊ��
index_start = 19;  % ��ֵ��ָ�꿪ʼ������
type_all = 'all_list';  % ���25000<������<50000,ѡ��'all_list'
for i=1:length(data_name_all)
    sheet_name_temp = sheet_name_all{i};
    data_name_temp = data_name_all{i};
    excel_data_preprocess(path, data_file_name_all, sheet_name_temp, data_name_temp, index_start, type_all);
end

%% ������ҵȷ��һ���޳���һ��������ָ��
% ������ָ��
path = ".\data\";
feature_del_remain_file_name = '�˹����屣�����޳���ָ��_ģ��.xlsx';
[~,indicators_name_add_old] = xlsread(path+feature_del_remain_file_name ,'����');
[row,~] = size(indicators_name_add_old);
indicators_name_add = {};
for i=1:row
    indicators_name_add{1,i} = indicators_name_add_old{i,1};
end
% �޳���ָ��
[~,indicators_name_del_old] = xlsread(path+feature_del_remain_file_name ,'�޳�');
[row2,~] = size(indicators_name_del_old);
indicators_name_del = {};
for i=1:row2
    indicators_name_del{1,i} = indicators_name_del_old{i,1};
end
save (path+'IndicatorAddDel_for_FirstFeaSelection_list.mat', 'indicators_name_add','indicators_name_del');

%% ����.mat����
dataset_name = {'all_list_std_data_save'};
temp_data_name = dataset_name{1}(1:8);  % ȡdataset_numǰ8���ַ���Ϊ��ʶ��
load_var_data_1 = string(temp_data_name)+'_std_data_1';  % ��ʶ������+ָ���׼��������ݼ�ΥԼ״̬(ǰ25000��)
load_var_data_2 = string(temp_data_name)+'_std_data_2';  % ��ʶ������+ָ���׼��������ݼ�ΥԼ״̬(25000֮���)
load_var_x_y_1 = string(temp_data_name)+'_std_x_y_1';  % ָ���׼��������ݼ�ΥԼ״̬(ǰ25000��)
load_var_x_y_2 = string(temp_data_name)+'_std_x_y_2';  % ָ���׼��������ݼ�ΥԼ״̬(25000֮���)
load_var_x_1 = string(temp_data_name)+'_std_x_1';  % ָ���׼���������(ǰ25000��)
load_var_x_2 = string(temp_data_name)+'_std_x_2';  % ָ���׼���������(25000֮���)
load_var_y_1 = string(temp_data_name)+'_std_y_1';  % ΥԼ״̬(ǰ25000��)
load_var_y_2 = string(temp_data_name)+'_std_y_2';  % ΥԼ״̬(25000֮���)
load_var_identity_1 = string(temp_data_name)+'_std_identity_1';  % ��ʶ��ָ��(֤ȯ�����)(ǰ25000��)
load_var_identity_2 = string(temp_data_name)+'_std_identity_2';  % ��ʶ��ָ��(֤ȯ�����)(25000֮���)
load_var_name = string(temp_data_name)+'_std_indicator_names';  % ָ������(�ʲ���ծ�ʵ�)
load_var_attr = string(temp_data_name)+'_std_indicator_attrs';  % ָ������(0:continuous; 1:discrete; 2:��ʶ��)
load ('.\data\'+string(dataset_name{1})+'.mat',load_var_data_1,load_var_data_2, load_var_x_y_1,load_var_x_y_2,...
    load_var_x_1, load_var_x_2, load_var_y_1, load_var_y_2, load_var_identity_1, load_var_identity_2, load_var_name,load_var_attr);  % �����Ӧ����
load ('.\data\IndicatorAddDel_for_FirstFeaSelection_list.mat','indicators_name_add','indicators_name_del');

%% ��������
% ���excel����
eval(['load_var_identity = ['+load_var_identity_1+';'+load_var_identity_2+'];']);  % ��ʶ��ָ��.
eval(['load_var_y = ['+load_var_y_1+'(3:end);'+load_var_y_2+'];']);  % ΥԼ״ָ̬��.
data_identity_y = [load_var_identity,num2cell(load_var_y)];   % ��ʶ��ָ��(֤ȯ�����)+ΥԼ״̬

eval(['load_var_data = ['+load_var_data_1+';'+load_var_data_2+'];']);  % data_cell�ĺϲ�.
eval(['all_indicator_names='+load_var_name+';']);
eval(['all_identity_names=load_var_data(2, 1:(index_start-1));']);
out_col_names = [all_identity_names, all_indicator_names];

% ����ָ����ѡ����������
eval(['data_x_y = ['+load_var_x_y_1+';'+load_var_x_y_2+'];']);  % ���������,����double��,���һ���Ǳ�ǩ.
eval(['feas_name = '+load_var_name+';']); % ���ݶ�Ӧ������,��cell��.
fea_remain = indicators_name_add; % Ҫ������ָ��
fea_del = indicators_name_del; % Ҫɾ����ָ��
threshold = 0.7;  % ���ϵ���ٽ��
criteria_num=[49, 105, 44, 23, 39, 8, 24, 3, 2, 53, 1];  % ÿ��׼������,��׼���ָ����ѡ
mark = temp_data_name;

%% Fֵ���ϵ��ָ����ѡ
[remained_data_corr_del_add,remained_name_corr_del_add,deleted_data_coor_del_add,deleted_name_coor_del_add] = feature_selection_corr(data_x_y, feas_name, threshold, criteria_num, fea_remain, fea_del, mark);
eval(['[~, fs_idx_temp] = ismember(remained_name_corr_del_add,'+load_var_name+');']);
eval(['attr_after_first_FeaSel = '+load_var_attr+'(fs_idx_temp(1:end-1));']);  % ��һ��ָ����ѡ���������ɢ�������
eval(['[fs_first_in, ~] = ismember('+load_var_name+',remained_name_corr_del_add);']);

%% ������������VIF��������the conditional number�������
R = corrcoef(remained_data_corr_del_add(:,1:end-1));
VIF = max(diag(inv(R))); % variance inflation factor.VIF<5����Ϊ�޹�����; 5<=VIF<=10,,�еȳ̶ȹ�����;VIF>10,���ع�����.
cond_num = cond(R); % conditional number, cond<=100����Ϊ�޹�����;cond>100����Ϊ���ع�����.
corr_test_out = [ {'VIF������������(<5)','Cond_num������(<100)'}; num2cell([VIF, cond_num])];  % 

%% ����excel���,������֤
identity_x_y_after_first_FeaSel = [data_identity_y(1:end, 1:end-1), num2cell(remained_data_corr_del_add)]; % ��1��ָ����ѡ��,ѵ������--��ʶ��ָ��+ѵ������+��ʵΥԼ״̬
out_col_names = [all_identity_names, remained_name_corr_del_add];
t=now;
time_out = [datestr(t,'yyyy.mm.dd') datestr(t,'.hh��mm.')];
xlswrite('.\data\data_out\'+string(temp_data_name)+'.'+string(time_out)+'Fֵ���ϵ��ָ����ѡ���.xlsx',[out_col_names;identity_x_y_after_first_FeaSel],'��1��ָ����ѡ�������') % ��1��ָ����ѡ�����������
xlswrite('.\data\data_out\'+string(temp_data_name)+'.'+string(time_out)+'Fֵ���ϵ��ָ����ѡ���.xlsx',corr_test_out,'��1��ָ����ѡ�������Լ���') % ��1��ָ����ѡ�������Լ���
