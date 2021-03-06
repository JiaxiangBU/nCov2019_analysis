上海疫情情况
================

``` r
library(tidyverse)
library(fs)
```

``` r
# "../src/utils.py"
df <- read_csv("../data/daily.csv")
```

``` r
shanghai_df <- df %>%
    filter(lubridate::month(updateDate) >= 2) %>%
    filter(provinceName %>% str_detect('上海')) %>%
    group_by(updateDate) %>%
    summarise(confirmed = sum(confirmed)) %>%
    ungroup() %>%
    arrange(updateDate) %>%
    mutate(growth_rate = log(confirmed),
           growth_rate = c(NA, diff(growth_rate)))
pudong_df <-
    df %>%
    filter(lubridate::month(updateDate) >= 2) %>%
    filter(provinceName %>% str_detect('上海')) %>%
    filter(cityName %>% str_detect('外地|浦东')) %>%
    group_by(updateDate, cityName) %>%
    summarise(confirmed = sum(confirmed)) %>%
    ungroup() %>%
    group_by(cityName) %>%
    arrange(updateDate) %>%
    mutate(growth_rate = log(confirmed),
           growth_rate = c(NA, diff(growth_rate)))

p1 <-
    shanghai_df %>%
    ggplot() +
    aes(x = updateDate, y = growth_rate) +
    geom_smooth(color = add2ggplot::red_one, linetype = 3) +
    geom_line(color = add2ggplot::red_one) +
    add2ggplot::theme_grey_and_red()
```

``` r
p1 +
    geom_text(aes(
        label = glue::glue("{scales::percent(growth_rate)}\n(累计{confirmed})")
    ),
    color = add2ggplot::white_one) +
    labs(
        y = '增长率',
        x = '更新日期',
        caption = '备注: 虚线为拟合线',
        title = '数据有点异常，9号以后跌的太厉害，本身是返工潮'
    ) +
    scale_x_date(date_breaks = "1 day", date_labels = "%m-%d(周%w)") +
    theme(axis.text.x = element_text(angle = 90))
image_path <- here::here("output/shanghai-growth-rate.png")
    ggsave(image_path,
           height = 5,
           width = 10)
knitr::include_graphics(image_path)
```

<img src="D:/work/nCov2019_analysis/output/shanghai-growth-rate.png" width="3000" />

``` r
bind_rows(shanghai_df %>% mutate(cityName = '上海市'), pudong_df) %>% 
    ggplot() +
    aes(x = updateDate, y = growth_rate, color = cityName) +
    geom_line() +
    add2ggplot::theme_grey_and_red() +
    geom_text(aes(
        label = glue::glue("{scales::percent(growth_rate)}\n(累计{confirmed})")
    ),
    color = add2ggplot::white_one,
    check_overlap  = TRUE) +
    labs(
        y = '增长率',
        x = '更新日期',
        title = '浦东波动很厉害，反弹很强'
    ) +
    scale_x_date(date_breaks = "1 day", date_labels = "%m-%d(周%w)") +
    theme(axis.text.x = element_text(angle = 90))
image_path <- here::here("output/pudong-growth-rate.png")
    ggsave(image_path,
           height = 5,
           width = 10)
knitr::include_graphics(image_path)
```

<img src="D:/work/nCov2019_analysis/output/pudong-growth-rate.png" width="3000" />
