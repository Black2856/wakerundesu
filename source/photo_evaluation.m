%resultフォルダ:結果の写真をtierフォルダごとに分類する
%sampleフォルダ:利用者が指定したいくつかの綺麗な写真を閾値とする
%targetフォルダ:分類したい写真が格納されている

%(返り値 成功かどうか:boolean) (引数: サンプルディレクトリ,ターゲットディレクトリ)
function result = photo_evaluation(sample_FP,target_FP,resultName,tol)
result = false;

try
tolerance = tol; %許容値(±x%)
sampleImds = imageDatastore(string(sample_FP),'IncludeSubfolders',true,'LabelSource','foldernames');
targetImds = imageDatastore(string(target_FP),'IncludeSubfolders',true,'LabelSource','foldernames');
catch
end

%進行度計算
CSImds = countEachLabel(sampleImds);
CTImds = countEachLabel(targetImds);
progress = [0 , CSImds{1,2} + CTImds{1,2}];
set_prog([progress(1) , progress(2)]);

%サンプルイメージ評価
try
    sampleEvaluation = FFT_evaluation(sampleImds);
catch
    msgbox('サンプルディレクトリのパスが正しく読み取れませんでした','エラー','error');
    return;
end

%ターゲットイメージ評価
try
    targetEvaluation = FFT_evaluation(targetImds);
catch
    msgbox('ターゲットディレクトリのパスが正しく読み取れませんでした','エラー','error');
    return;
end

%閾値計算
threshold = mean(sampleEvaluation) * (1 + tolerance);

%ディレクトリ作成
mkdir(string(resultName)+'\ブレあり\');
mkdir(string(resultName)+'\ブレなし\');

%分類
for i = 1:1:size(targetEvaluation,2)
    if threshold < targetEvaluation(i)
        copyfile(string(targetImds.Files(i)),string(resultName)+'\ブレあり\');
    else
        copyfile(string(targetImds.Files(i)),string(resultName)+'\ブレなし\');
    end
    
end
msgbox({'分類の処理が終了しました。';'結果のディレクトリは "'+string(resultName)+'" に出力されました。.'},'処理完了');
result = true;

end