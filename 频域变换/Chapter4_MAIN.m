clc;clear;close all;
% 
method = 2;
switch method
    case 1
        % 可视化二维DFT
        image_rectangle = imread('Fig0424(a)(rectangle).tif');
        fft_rectangle = fft2(image_rectangle);      % 求傅里叶频谱
        out_rectangle = abs(fft_rectangle);
        out_rectangle_mid = fftshift(fft_rectangle);    % 居中频谱
        out_rectangle_log = log(1 + abs(out_rectangle_mid));
        % 对频谱使用对数变换进行视觉增强
        figure;
        subplot(221);
        imshow(image_rectangle);
        title('原图');
        subplot(222);
        imshow(out_rectangle, [ ]);
        title('FFT之后的图像');
        subplot(223);
        imshow(abs(out_rectangle_mid), [ ]);
        title('居中后的图像');
        subplot(224);
        imshow(out_rectangle_log, [ ]);
        title('对数增强后的图像');
        
    case 2
        % 读取房子图像求傅里叶变换
        image_house = imread('Fig0438(a)(bld_600by600).tif');
        fft_house = fft2(image_house);
        out_house_1 = fftshift(log(1 + abs(fft_house)));    % 频谱居中
        out_house_2 = gscale(out_house_1);  % 把图像标度在全尺度
        figure;
        subplot(121);
        imshow(image_house);
        title('原图');
        subplot(122);
        imshow(out_house_2);
        title('傅里叶频谱');
        filter_house_s = fspecial('sobel');     % Create predefined 2-D filter
        PQ_house = paddedsize(size(image_house));   % 获得填充参数
        % 求频率响应
        filter_house_soble = freqz2(filter_house_s, PQ_house(1), PQ_house(2));
        filter_house_f = ifftshift(filter_house_soble);
        figure;
        subplot(121);
        imshow(abs(filter_house_soble), [ ]);
        title('soble掩模的频域滤波器绝对值');
        subplot(122);
        imshow(abs(filter_house_f), [ ]);
        title('fftshift后的同一滤波器');
        % 空间域滤波
        out_house_s = imfilter(double(image_house), filter_house_s);
        % 频域滤波
        out_house_f = dftfilt(image_house, filter_house_f);
        figure;
        subplot(321);
        imshow(out_house_s, [ ]);
        title('空间域使用垂直Soble掩模滤波结果');
        subplot(322);
        imshow(out_house_f, [ ]);
        title('频域滤波结果');
        subplot(323);
        imshow(abs(out_house_s), [ ]);
        title('绝对值');
        subplot(324);
        imshow(abs(out_house_f), [ ]);
        title('绝对值');
        subplot(325);
        imshow(abs(out_house_s) > 0.2*abs(max(out_house_s(:))));
        title('阈值处理后的边缘图像');
        subplot(326);
        imshow(abs(out_house_f) > 0.2*abs(max(out_house_f(:))));              
        title('阈值处理后的边缘图像');
        
    case 3
        % 低通滤波图像
        image_a_lp = imread('Fig0441(a)(characters_test_pattern).tif');
        PQ_a = paddedsize(size(image_a_lp));   % 求填充参数
        [U_a, V_a] = dftuv(PQ_a(1),PQ_a(2));    
        % 提供距离计算及其他类似应用所需要的网格数组
        % 由dftuv生成的网格数组已满足fft2和ifft2的处理的需要
        D0_a = 0.05*PQ_a(2);    % 使用的D0值等于填充后的图像宽度的5%
        F_a = fft2(image_a_lp, PQ_a(1), PQ_a(2));   % 填充图像
        H_a = exp(-(U_a.^2 + V_a.^2)/(2*(D0_a^2))); % 滤波器响应
        g_a = dftfilt(image_a_lp, H_a);     % 频域滤波
        figure;
        subplot(121);
        imshow(image_a_lp, [ ]);
        title('原图');
        subplot(122);
        imshow(g_a, [ ]);
        title('低通滤波后的模糊图像');
        
    case 4
        % 高通滤波图像
        image_a_hp = imread('Fig0441(a)(characters_test_pattern).tif');
        PQ_a_1 = paddedsize(size(image_a_hp));
        D0_a_1 = 0.05*PQ_a_1(1);
        H_a_1 = hpfilter('gaussian', PQ_a_1(1), PQ_a_1(2), D0_a_1);
        g_a_1 = dftfilt(image_a_hp, H_a_1);
        figure;
        subplot(121);
        imshow(image_a_hp, [ ]);
        title('原图');
        subplot(122);
        imshow(g_a_1, [ ]);
        title('高通滤波后的锐化图像');
        
    case 5
        % 本例目的是锐化图像f，由于X光图像不能像光学透镜一样聚焦，所以结果模糊。
        % 由于这幅图像的灰度偏向于灰度级的暗端，所以还将利用这个机会说明如何使用
        % 空间域处理来补偿频域滤波。
        % 读取一幅胸部的X光图像f
        f = imread('Fig0459(a)(orig_chest_xray).tif');
        PQ = paddedsize(size(f));
        D0 = 0.05*PQ(1);    % D0的值等于已填充图像垂直尺寸的5%
        HBW = hpfilter('btw', PQ(1), PQ(2), D0, 2); % 高通滤波
        H = 0.5 + 2*HBW;
        gbw = dftfilt(f, HBW);  % 频域高通滤波
        gbw = gscale(gbw);
        ghf = dftfilt(f, H);    % 高频强调滤波
        ghf = gscale(ghf);
        ghe = histeq(ghf, 256); % 直方图均衡
        figure;
        subplot(221);
        imshow(f);
        title('原图');
        subplot(222);
        imshow(gbw);
        title('高频滤波后');
        subplot(223);
        imshow(ghf);
        title('高频强调滤波后');
        subplot(224);
        imshow(ghe);
        title('直方图均衡后');
end







