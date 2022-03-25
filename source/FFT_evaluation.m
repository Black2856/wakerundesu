function ret = FFT_evaluation(imds)

arguments %型指定
    imds matlab.io.datastore.ImageDatastore
end
    
evaluation = [];
imds_count = countEachLabel(imds);

%画像読み込み
for count = 1:imds_count{1,2}
img = readimage(imds,count);

if size(img,1) < size(img,2)%イメージのリサイズ
    maxSize = size(img,1);
else
    maxSize = size(img,2);
end
resizeImg = imresize(img, [maxSize,maxSize]);

%グレースケール変換
BW = rgb2gray(resizeImg);

%FFT処理
FFT = fft2(BW);
FFT = abs(fftshift(FFT));
FFT = log10(FFT);

%データスケーリング処理
FFT_X = normalize(sum(FFT),'range');
FFT_Y = normalize(sum(FFT,2),'range')';

FFT_X_kur = kurtosis(FFT_X);
FFT_Y_kur = kurtosis(FFT_Y);
FFT_kur_AVG = (FFT_X_kur + FFT_Y_kur)/2;

%後処理
evaluation = [evaluation,FFT_kur_AVG];

%進行度更新
progress = get_prog();
set_prog([progress(1) + 1 , progress(2)])

end

ret = evaluation;

end