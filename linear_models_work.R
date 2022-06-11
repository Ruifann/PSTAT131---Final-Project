```{r}
reg_rms <- lm(sale_price ~ tot_rms_abv_grd, data = select_train)
summary(reg_rms)
```

```{r}
reg_qual <- lm(sale_price ~ overall_qual, data = select_train)
summary(reg_qual)
```

```{r}
reg <- lm(sale_price~.-sale_price, data = select_train)
summary(reg)
```

```{r}
reg <- lm(sale_price~ overall_qual + overall_cond + year_built + gr_liv_area + kitchen_abv_gr + fireplaces + garage_area + pool_area, data = select_train)
summary(reg)
```


```{r}
reg1 <- lm(sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces + garage_area, data = select_train)
summary(reg1)
```

```{r}
reg2 <- lm(sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces, data = select_train)
summary(reg2)
```

```{r}
reg_multi <- lm(sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces, data = select_train)
summary(reg_multi)
```


```{r}
house_recipe <- recipe(sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces + garage_area, data = train)
```

```{r}
lm_model <- linear_reg() %>% 
  set_engine("lm")
lm_wflow <- workflow() %>% 
  add_model(lm_model) %>% 
  add_recipe(house_recipe)
```

```{r}
lm_fit <- fit(lm_wflow, train)
```


```{r}
lm_fit %>%
  extract_fit_parsnip() %>% 
  tidy()
```

```{r}
test_res <- predict(lm_fit, new_data = test %>% select(-sale_price))
test_res %>% 
  head()

```

```{r}
test_res <- bind_cols(test_res, test %>% select(sale_price))
test_res %>% 
  head()
```


```{r}
test_res %>% 
  ggplot(aes(x = .pred, y = sale_price)) +
  geom_point(alpha = 0.2) +
  geom_abline(lty = 2) + 
  theme_bw() +
  coord_obs_pred()
```


```{r}
predict_metrics <- metric_set(rmse, rsq, mae)
predict_metrics(test_res, truth = sale_price, 
                estimate = .pred)
```

