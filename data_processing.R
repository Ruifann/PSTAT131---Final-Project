```{r}
library(recipes)
library(workflows)
library(dplyr)
library(parsnip)
library(tidymodels)
library(ISLR)
library(ISLR2)
library(tidyverse)
library(glmnet)
tidymodels_prefer()
library(ggplot2)
library(readr)
library(gplots)
library(repr)
library(caret)
library(rpart.plot)
library(vip)
```
```{r}
library(discrim)
library(poissonreg)
library(corrr)
library(klaR) # for naive bayes
```

```{r}
library(janitor)
library(rsample)
```

```{r}
train_data <- read_csv("~/Downloads/house_prices/train.csv") %>%
  clean_names()
```

```{r}
test_data <- read_csv("~/Downloads/house_prices/test.csv") %>%
  clean_names()
```



```{r}
missing_row <- train_data[!complete.cases(train_data),]
head(missing_row)
```

```{r}
variables <- names(train_data)
variables
```

```{r}
select_train <- train_data %>%
  select(overall_qual,overall_cond,year_built, gr_liv_area, bedroom_abv_gr, kitchen_abv_gr, tot_rms_abv_grd, 
         fireplaces, garage_area, open_porch_sf, pool_area, mo_sold, yr_sold, sale_price)
head(select_train)
```


```{r}
summary(select_train$sale_price)
```

```{r}
select_train <- select_train %>%
  mutate(sale_price = log(sale_price))
```
```{r}
summary(select_train$sale_price)
```

```{r}
typeof(select_train)
names(select_train)
```

```{r}
set.seed(123)

select_split <- initial_split(select_train, prop = 0.80,
                              strata = sale_price)
train <- training(select_split)
test <- testing(select_split)
```

```{r}
summary(train$pool_area)
```