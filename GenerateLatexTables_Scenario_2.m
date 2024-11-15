%% Generate Main Contents of Latex Tables

% fid = fopen('LatexTable_Table_1.txt','w');
% 
% fprintf(fid, 'WienerCE      & %.2f      & %.2e      & WienerCE-DL     & %.2f    & %.2e \\\\\n', mean(Test_error_WienerCE), mean(Train_Time_WienerCE), mean(Test_error_WienerCE_DL), mean(Train_Time_WienerCE_DL));
% fprintf(fid, '\\hline\n');
% fprintf(fid, '              &           &           & WienerCE-DR     & %.2f    & %.2e \\\\\n', mean(Test_error_WienerCE_DR), mean(Train_Time_WienerCE_DR));
% fprintf(fid, '\\hline\n');
% fprintf(fid, 'Capon         & %.2f      & %.2e      & Capon-DL        & %.2f    & %.2e \\\\\n', mean(Test_error_Capon), mean(Train_Time_Capon), mean(Test_error_Capon_DL), mean(Train_Time_Capon_DL));
% fprintf(fid, '\\hline\n');
% fprintf(fid, 'ZF            & %.2f      & %.2e      & Wiener          & %.2f    & %.2e \\\\\n', mean(Test_error_ZF), mean(Train_Time_ZF), mean(Test_error_Wiener), mean(Train_Time_Wiener));
% fprintf(fid, '\\hline\n');
% fprintf(fid, 'Wiener-DL     & %.2f      & %.2e      & Wiener-DR-F     & %.2f    & %.2e \\\\\n', mean(Test_error_Wiener_DL), mean(Train_Time_Wiener_DL), mean(Test_error_WienerDR_F), mean(Train_Time_WienerDR_F));
% 
% fclose(fid);
% 
% 

%% Generate Main Contents of Latex Tables

fid = fopen('LatexTable.txt','w');

fprintf(fid, 'Wnr           & %.2f      & %.2e      & Wnr-DL          & %.2f    & %.2e \\\\\n', mean(Test_error_Wiener), mean(Train_Time_Wiener), mean(Test_error_Wiener_DL), mean(Train_Time_Wiener_DL));
fprintf(fid, '\\hline\n');
fprintf(fid, 'Wnr-DR        & %.2f      & %.2e      & Wnr-CE          & %.2f    & %.2e \\\\\n', mean(Test_error_Wiener_DR_F), mean(Train_Time_Wiener_DR_F), mean(Test_error_Wiener_CE), mean(Train_Time_Wiener_CE));
fprintf(fid, '\\hline\n');
fprintf(fid, 'Wnr-CE-DL     & %.2f      & %.2e      & Wnr-CE-DR       & %.2f    & %.2e \\\\\n', mean(Test_error_Wiener_CE_DL), mean(Train_Time_Wiener_CE_DL), mean(Test_error_Wiener_CE_DR), mean(Train_Time_Wiener_CE_DR));
fprintf(fid, '\\hline\n');
fprintf(fid, 'Capon         & %.2f      & %.2e      & Capon-DL        & %.2f    & %.2e \\\\\n', mean(Test_error_Capon), mean(Train_Time_Capon), mean(Test_error_Capon_DL), mean(Train_Time_Capon_DL));
fprintf(fid, '\\hline\n');
fprintf(fid, 'ZF            & %.2f      & %.2e      & Kernel          & %.2f    & %.2e \\\\\n', mean(Test_error_ZF), mean(Train_Time_ZF), mean(Test_error_Kernel), mean(Train_Time_Kernel));
fprintf(fid, '\\hline\n');
fprintf(fid, 'Kernel-DL     & %.2f      & %.2e      &                 &         &      \\\\\n', mean(Test_error_Kernel_DL), mean(Train_Time_Kernel_DL));

fclose(fid);




