

local imagesPath = _G.defaultImagesPath;
local imagesExt = _G.defaultImageExtension;

local numbers = _G.numberOfOperation;
local limitMin = _G.limitMin;
local limitMax = _G.limitMax;
local mRandom = math.random;

local totalWidth = _G.totalWidth;
local totalHeight = _G.totalHeight;

local help = {};


help.localizableImage = function (inputString)
    local langId = "_eng";
    if (system.getPreference( "ui", "language") == "ru") then
        langId = "_rus";
    end
    return imagesPath..inputString..langId..imagesExt;
end

help.imagePath = function (inputString)
    return imagesPath..inputString..imagesExt;
end

help.getSite = function()
    local str;
    if (system.getPreference( "ui", "language") == "ru") then
        str = _G.siteRus;
    else
        str = _G.siteEng;
    end
    return str;
end

help.generateArrayWithNumber = function (coeficient) 
    _G.coeficient = coeficient;
    local array = {};
    array["first"] = {};
    array["second"] = {};
    local allVariants = {};
    local x = 1;
    local iStart, iFinish = limitMin, limitMax;
    if (coeficient ~= -1) then 
        iStart, iFinish = coeficient, coeficient;
    end
    for i = iStart, iFinish do
        for j = limitMin, limitMax do
            allVariants[x] = {};
            allVariants[x]["first"] = i;
            allVariants[x]["second"] = j;
            x = x + 1;
        end
    end
    
    for i = 1, numbers do
        count = #allVariants;
        local randomIndex = mRandom(1,count);
        array["first"][i] = allVariants[randomIndex]["first"];
        array["second"][i] = allVariants[randomIndex]["second"];
        table.remove(allVariants, randomIndex);
    end
    _G.randomNumber = array;

end

help.sizes = function (width, heigth)
    width = width * 2;
    heigth = heigth * 2;
    local coeficientWidth = width / 768;
    local locWidth = coeficientWidth * totalWidth;
    local coeficienHeight = heigth / width;
    local locHeight = coeficienHeight * locWidth;
    return locWidth, locHeight;
    
end


return help;
