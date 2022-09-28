# read in data
cod_og <- readxl::read_excel('Data/cause_of_death_raw.xlsx')

#shuffle order and delete 2%
cod_shuffle <- cod_og[sample(.98*nrow(cod_og)),]

#randomly duplicate some
small_cod <- cod_og[sample(.02*nrow(cod_og)),]
cod_final <- rbind(cod_shuffle, small_cod)

# save to xlsx
#openxlsx::write.xlsx(cod_final, 'Data/cause_of_death_final.xlsx')

#rename
names(cod_final) <- 'cause'

write.csv(cod_final, 'Data/cause_of_death.csv', row.names = FALSE)

sales <- c(rep('orange juice', 10),
           '  orange juice',
           rep('apple juice', 5),
           rep('ORANGE juice', 3),
           rep('OJ',8),
           '   Apple   Juice  ',
           rep('orange   juice',3),
           'orange juice, apple juice, orange juice',
           'orange drink',
           '  apple drink')

juice_sales = data.frame(juice = sales[sample(length(sales))])

write.csv(juice_sales, 'Data/juice_sales.csv', row.names = FALSE)
