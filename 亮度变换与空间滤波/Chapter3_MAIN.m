clc;clear;close all;
% 1:乳房图像处理
% 2:对数拉伸
% 3:INTRANS函数
% 4:GSCALE亮度标度
% 5:直方图均衡
method = 7;
switch method
    case 1
        % Read the image of breast digital Xray
        % Compute the negative of input image
        image_breast = imread('Fig0304(a)(breast_digital_Xray).tif');
        out_breast_1 = imcomplement(image_breast);
        % out_breast_1 = imadjust(image_breast,[0 1],[1 0]);
        out_breast_2 = imadjust(image_breast,[0.5 0.75],[0 1]);
        out_breast_3 = imadjust(image_breast,[ ],[ ],2);
        figure;
        subplot(221);
        imshow(image_breast);
        title('原始数字乳房图像');
        subplot(222);
        imshow(out_breast_1);
        title('负片图像');
        subplot(223);
        imshow(out_breast_2);
        title('亮度范围扩展为[0.5 0.75]的结果');
        subplot(224);
        imshow(out_breast_3);
        title('使用gamma=2增强图像之后的结果');
        
    case 2
        % 对数拉伸变换
        image_dft = imread('Fig0305(a)(DFT_no_log).tif');
        out_log_1 = im2uint8(mat2gray(log(1 + double(image_dft))));
        out_log_2 = intrans(image_dft, 'log');
        figure;
        subplot(221);
        imshow(image_dft);
        title('原始图像');
        subplot(222);
        imshow(out_log_1);
        title('对数变换');
        subplot(223);
        imshow(out_log_2);
        title('INTRANS对数变换');
        
    case 3
        % INTRANS函数
        image_skeleton = imread('Fig0343(a)(skeleton_orig).tif');
        out_skeleton_str = intrans(image_skeleton, 'stretch', mean2(im2double(image_skeleton)), 0.9);
        out_skeleton_neg = intrans(image_skeleton, 'neg');
        out_skeleton_log = intrans(image_skeleton, 'log');
        out_skeleton_gamma = intrans(image_skeleton, 'gamma', 2);
        figure;
        subplot(221);
        imshow(image_skeleton);
        title('origin image');
        subplot(222);
        imshow(out_skeleton_str);
        title('after log-stretch');
        subplot(223);
        imshow(out_skeleton_neg);
        title('negative image');
        subplot(224);
        imshow(out_skeleton_gamma);
        title('gamma=2');
        
    case 4
        % GSCALE 亮度标度函数
        % 将输出映射到[0 255]范围内
        image_spine = imread('Fig0308(a)(fractured_spine).tif');
        out_gscale = gscale(image_spine, 'minmax', 0, 1);
        figure;
        subplot(121);
        imshow(image_spine);
        subplot(122);
        imshow(out_gscale);
        
    case 5
        % 直方图均衡
        image_flower = imread('Fig0316(4)(bottom_left).tif');
        out_balance = histeq(image_flower,256);
        figure;
        subplot(221);
        imshow(image_flower);
        subplot(222);
        imhist(image_flower);
        ylim('auto');
        subplot(223);
        imshow(out_balance);
        subplot(224);
        imhist(out_balance);
        ylim('auto');
        % Transformation
        hnorm = imhist(image_flower)./numel(image_flower);
        cdf = cumsum(hnorm);
        x = linspace(0, 1, 256);    % Intervals for [0,1] horiz scale. Note
                                    % the use of linspace from Sec. 2.8.1.
        figure;
        plot(x,cdf);                % plot cdf vs. x.
        axis([0 1 0 1]);
        set(gca, 'xtick', 0:0.2:1);
        set(gca, 'ytick', 0:0.2:1);
        xlabel('Input intensity values', 'fontsize', 9);
        ylabel('Output intensity values', 'fontsize', 9);
        % Specify text in the body of the graph:
        text(0.18, 0.5, 'Transformation function', 'fontsize', 9);
        
    case 6
        % 直方图匹配
        image_mars = imread('Fig0323(a)(mars_moon_phobos).tif');
        out_balance_mars = histeq(image_mars,256);
        figure;
        subplot(321);
        imshow(image_mars);
        subplot(322);
        imhist(image_mars);
        ylim('auto');
        subplot(323);
        imshow(out_balance_mars);
        subplot(324);
        imhist(out_balance_mars);
        ylim('auto');
        manuhist = optionhist();
        out_balance_manu = histeq(image_mars,manuhist);
        subplot(325);
        imshow(out_balance_manu);
        subplot(326);
        imhist(out_balance_manu);
        ylim('auto');
        
    case 7
        % 滤波器掩模
        image_moon = im2double(imread('Fig0338(a)(blurry_moon).tif'));
        w1 = fspecial('laplacian', 0);  % Same as w in Example 3.9
        w2 = [1 1 1; 1 -8 1; 1 1 1];
        out_moon_1 = image_moon - imfilter(image_moon, w1, 'replicate');
        out_moon_2 = image_moon - imfilter(image_moon, w2, 'replicate');
        figure;
        subplot(131);
        imshow(image_moon);
        title('月球北极图像');
        subplot(132);
        imshow(out_moon_1);
        title('中心为-4的拉普拉斯滤波器');
        subplot(133);
        imshow(out_moon_2);
        title('中心为-8的拉普拉斯滤波器');
end






