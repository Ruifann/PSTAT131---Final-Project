```{r}
hist(select_train$sale_price, xlab = "sale price", ylab = "counts", xlim = c(30000, 760000), main = "Histogram of sale price")
```

```{r}
ggplot(select_train, aes(x = tot_rms_abv_grd, y = sale_price)) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red")
```

```{r}
cor_select <- select_train %>%
  correlate()
```

```{r}
rplot(cor_select)
```

```{r}
cor_select %>%
  stretch() %>%
  ggplot(aes(x, y, fill = r)) +
  geom_tile() +
  geom_text(aes(label = as.character(fashion(r))))+
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  NULL
```

```{r}
ggplot(select_train, aes(x = overall_qual, y = sale_price)) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red")
```

```{r}
class.tree <- rpart(sale_price~ overall_qual + overall_cond + year_built + gr_liv_area  + fireplaces + garage_area + central_air + heating_qc + exter_cond,
                    data = new_train, control = rpart.control(cp = 0.01))

plotcp(class.tree)
printcp(class.tree)
```

```{r}
rpart.plot(class.tree)
```

```{r}
reg_tree_fit %>%
  extract_fit_engine() %>%
  rpart.plot()
```

```{r}
reg_tree_final_fit %>%
  extract_fit_engine() %>%
  rpart.plot()
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
augment(rf_fit, new_data = new_test) %>%
  ggplot(aes(sale_price, .pred)) +
  geom_abline() +
  geom_point(alpha = 0.5)
```

```{r}
vip(rf_fit)
```