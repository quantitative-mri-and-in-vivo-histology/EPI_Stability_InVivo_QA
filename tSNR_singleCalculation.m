clc; clear all;

Vol_EPI_header_1 = niftiinfo('Cima.X_DICOMs_Volunteer_ep2d_bold-moco_p2_s2_Fleet_ref_PSN_20230720100726_14.nii');
Vol_EPI_header_2 = niftiinfo('Cima.X_DICOMs_Volunteer_ep2d_bold-moco_p2_s2_Fleet_ref_PSN_20230720100726_15.nii');

Vol_EPI_1 = double(niftiread('Cima.X_DICOMs_Volunteer_ep2d_bold-moco_p2_s2_Fleet_ref_PSN_20230720100726_14.nii'));
Vol_EPI_2 = double(niftiread('Cima.X_DICOMs_Volunteer_ep2d_bold-moco_p2_s2_Fleet_ref_PSN_20230720100726_15.nii'));

mean_vol1 = mean(Vol_EPI_1,4);
mean_vol2 = mean(Vol_EPI_2,4);

tSNR_vol1 = mean_vol1./std(Vol_EPI_1,[],4);
tSNR_vol2 = mean_vol2./std(Vol_EPI_2,[],4);

Vol_EPI_header_1.Datatype = 'double';
Vol_EPI_header_1.BitsPerPixel = '64';
Vol_EPI_header_1.ImageSize = [108, 108, 60];
Vol_EPI_header_1.PixelDimensions = [1.712960004806519,1.712960004806519,1.700000047683716];
niftiwrite(tSNR_vol1,'CimaX_Volunteer_MeanVol_14.nii',Vol_EPI_header_1);
niftiwrite(tSNR_vol1,'CimaX_Volunteer_tSNR_14.nii',Vol_EPI_header_1);

Vol_EPI_header_2.Datatype = 'double';
Vol_EPI_header_2.BitsPerPixel = '64';
Vol_EPI_header_2.ImageSize = [108, 108, 60];
Vol_EPI_header_2.PixelDimensions = [1.712960004806519,1.712960004806519,1.700000047683716];
niftiwrite(tSNR_vol2,'CimaX_Volunteer_MeanVol_15.nii',Vol_EPI_header_2);
niftiwrite(tSNR_vol2,'CimaX_Volunteer_tSNR_15.nii',Vol_EPI_header_2);

%% Figures

MaskBrain =  double(niftiread('BrainMask.nii'));

size_vol = size(tSNR_vol1);
mosaic_image = [];
for slice_indx_1 = 1:10
    for slice_indx_2 = 1:6
        mosaic_image(((slice_indx_1 - 1)*size_vol(1) + 1):slice_indx_1*size_vol(1),...
                     ((slice_indx_2 - 1)*size_vol(2) + 1):slice_indx_2*size_vol(2)) = tSNR_vol1(:,:,slice_indx_2 + 6*(slice_indx_1-1));
    end
end

figure(1), imagesc(mosaic_image);

size_vol = size(tSNR_vol2);
mosaic_image = [];
for slice_indx_1 = 1:10
    for slice_indx_2 = 1:6
        mosaic_image(((slice_indx_1 - 1)*size_vol(1) + 1):slice_indx_1*size_vol(1),...
                     ((slice_indx_2 - 1)*size_vol(2) + 1):slice_indx_2*size_vol(2)) = tSNR_vol2(:,:,slice_indx_2 + 6*(slice_indx_1-1));
    end
end

figure(2), imagesc(mosaic_image);

figure(3); histogram(tSNR_vol1(MaskBrain(:) > 0.9)); hold on; histogram(tSNR_vol2(MaskBrain(:) > 0.9));
