### Queries

Simple search - `FT.SEARCH <index> <query>` // default result size is 10
```
FT.SEARCH permits garage
```
OR query - `ft.search permits garage|carport`
AND query - `ft.search permits "garage carport" limit 0 0`

`ft.explaincli permits carport|garage` // Gives details about the query execution plan. This command is useful for debugging queries.

`ft.search permits "garage carport -demolish"` - Fetches documents with condition:  `garage AND carport AND not demolish`

`ft.search permits air* limit 0 0` // LIKE operator for wildcard searches

Fuzzy search uses the Levenshtein distance to find slightly misspelled words.
For fuzzy matching use `%<query>%`
`FT.SEARCH permits %greenhuse%` // returns both "greenhouse" and "greenhuse"

`ft.search permits "\"carport\"" limit 0 0` // For exact matching use "". Escape the double quotes also.
`ft.explaincli permits "\"green house\""`

Paren usage - `ft.explaincli permits "(underground parkade) | (parking lot)"` // Means (underground AND parkade) OR (parking AND lot)
`ft.explaincli permits "((underground parkade) | (parking lot) demolish)"`
Using NOT - `ft.explaincli permits "((underground parkade) | (parking lot) -demolish)"`
`ft.explaincli permits "((underground parkade) | (parking lot) -(demolish|remove))"`

RediSearch is based on set theory. 
