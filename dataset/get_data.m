function [data] = get_data()
CACHE_NAME = "../dataset/cache.mat";
cache_exists = isfile(CACHE_NAME);

if cache_exists
    data = load(CACHE_NAME);
else
    data = read_data_from_csv();
    save(CACHE_NAME, "data");
end
end