library(duckdb)

# Connect to a new DuckDB database in memory
con <- dbConnect(duckdb(), dbdir="palmerpenguins.duckdb", read_only=FALSE)
dbWriteTable(con, "penguins", palmerpenguins::penguins)
dbDisconnect(con, shutdown=TRUE)

# Verify that the table was created
con <- dbConnect(duckdb(), dbdir="palmerpenguins.duckdb", read_only=TRUE)
dbGetQuery(con, "SELECT * FROM penguins LIMIT 10")
dbDisconnect(con, shutdown=TRUE)

# Query with dbplyr
library(dplyr)
con <- dbConnect(duckdb(), dbdir="palmerpenguins.duckdb", read_only=TRUE)
tbl(con, "penguins") %>%
  group_by(species) %>%
  summarize(across(ends_with("mm"), ~mean(., na.rm=TRUE)))
dbDisconnect(con, shutdown=TRUE)
