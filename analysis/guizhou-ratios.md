贵州疫情情况
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
guizhou_df <- df %>%
    filter(lubridate::month(updateDate) >= 2) %>%
    filter(provinceName %>% str_detect('贵州')) %>%
    group_by(updateDate) %>%
    summarise(confirmed = sum(confirmed)) %>%
    ungroup() %>%
    arrange(updateDate) %>%
    mutate(growth_rate = log(confirmed),
           growth_rate = c(NA, diff(growth_rate)))
qiannanzhou_df <-
    df %>%
    filter(lubridate::month(updateDate) >= 2) %>%
    filter(provinceName %>% str_detect('贵州')) %>%
    filter(cityName %>% str_detect('黔南州')) %>%
    group_by(updateDate, cityName) %>%
    summarise(confirmed = sum(confirmed)) %>%
    ungroup() %>%
    group_by(cityName) %>%
    arrange(updateDate) %>%
    mutate(growth_rate = log(confirmed),
           growth_rate = c(NA, diff(growth_rate)))

p1 <-
    guizhou_df %>%
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
        title = '贵州确诊增长率基本稳定在10%'
    ) +
    scale_x_date(date_breaks = "1 day", date_labels = "%m-%d(周%w)") +
    theme(axis.text.x = element_text(angle = 90))
image_path <- here::here("output/guizhou-growth-rate.png")
    ggsave(image_path,
           height = 5,
           width = 10)
knitr::include_graphics(image_path)
```

<img src="D:/work/nCov2019_analysis/output/guizhou-growth-rate.png" width="3000" />

``` r
bind_rows(guizhou_df %>% mutate(cityName = '贵州省'), qiannanzhou_df) %>% 
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
        title = '黔南州水平是低于贵州水平'
    ) +
    scale_x_date(date_breaks = "1 day", date_labels = "%m-%d(周%w)") +
    theme(axis.text.x = element_text(angle = 90))
image_path <- here::here("output/qiannanzhou-growth-rate.png")
    ggsave(image_path,
           height = 5,
           width = 10)
knitr::include_graphics(image_path)
```

<img src="D:/work/nCov2019_analysis/output/qiannanzhou-growth-rate.png" width="3000" />
