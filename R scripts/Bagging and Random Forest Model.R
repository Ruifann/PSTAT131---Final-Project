```{r}
bagging_spec <- rand_forest(mtry = .cols()) %>%
  set_engine("randomForest", importance = TRUE) %>%
  set_mode("regression")
```

```{r}
bagging_fit <- fit(bagging_spec, sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces + garage_area + heating_qc + exter_cond, 
                   data = new_train)
```

```{r}
augment(bagging_fit, new_data = new_test) %>%
  rmse(truth = sale_price, estimate = .pred)
```

```{r}
augment(bagging_fit, new_data = new_test) %>%
  ggplot(aes(sale_price, .pred)) +
  geom_abline() +
  geom_point(alpha = 0.5)
```

```{r}
vip(bagging_fit)
```  

```{r}
rf_spec <- rand_forest(mtry = 6) %>%
  set_engine("randomForest", importance = TRUE) %>%
  set_mode("regression")
```

```{r}
rf_fit <- fit(rf_spec, sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces + garage_area + heating_qc + exter_cond, data = new_train)
```

```{r}
augment(rf_fit, new_data = new_train) %>%
  rmse(truth = sale_price, estimate = .pred)
```

```{r}
augment(rf_fit, new_data = new_test) %>%
  ggplot(aes(sale_price, .pred)) +
  geom_abline() +
  geom_point(alpha = 0.5)
```

```{r}
vip(rf_fit)
```