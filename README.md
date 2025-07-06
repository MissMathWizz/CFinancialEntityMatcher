# Financial Entity Matcher

A powerful R-based tool for fuzzy matching company names across financial datasets, with specialized focus on Chinese market data (CSI700) and compliance screening.

## 🎯 Purpose

This tool helps financial institutions and analysts:
- **Match company names** across different datasets with varying naming conventions
- **Screen Chinese companies** against sanctions lists for compliance
- **Map stock tickers to ISINs** and other identifiers
- **Resolve data quality issues** caused by name variations, translations, and formatting differences

## 🚀 Features

### Advanced Fuzzy Matching
- **Multiple algorithms**: Jaro-Winkler, Edit Distance, Q-gram, TF-IDF
- **Hybrid approach**: Combines R and Python libraries for optimal results
- **Configurable thresholds**: Adjustable similarity scores for different use cases

### Specialized for Financial Data
- **CSI700 Index**: Built-in support for Chinese stock market data
- **Sanctions screening**: Cross-reference companies against compliance databases
- **ISIN mapping**: Link company names to International Securities Identification Numbers
- **Multi-language support**: Handles English and Chinese company names

### Export & Integration
- **Excel output**: Results exported to structured spreadsheets
- **Similarity scores**: Confidence levels for each match
- **Batch processing**: Handle large datasets efficiently

## 📋 Requirements

### R Dependencies
```r
install.packages(c(
  "readxl",      # Excel file reading
  "writexl",     # Excel file writing
  "dplyr",       # Data manipulation
  "fuzzyjoin",   # Fuzzy joining
  "stringdist",  # String distance calculations
  "reticulate",  # Python integration
  "fuzzywuzzyR"  # Advanced fuzzy matching
))
```

### Python Dependencies (Optional)
```bash
pip install difflib polyfuzz
```

## 📁 Project Structure

```
├── Mapping.R              # Main mapping script
├── Fuzzymatching.R        # Advanced fuzzy matching algorithms
├── CSI700_saction_mapping.xlsx  # Input data file
├── Get_ISIN_by_Tickers.Rproj   # R project file
└── README.md              # This file
```

## 🔧 Usage

### Basic Usage

1. **Prepare your data**: Place your Excel file with company data in the project directory
2. **Run the mapping script**:
   ```r
   source("Mapping.R")
   ```
3. **Check results**: Output will be saved to `/Users/yw/Downloads/almat.xlsx`

### Advanced Fuzzy Matching

For more sophisticated matching with multiple algorithms:
```r
source("Fuzzymatching.R")
```

### Customization

#### Adjust Similarity Threshold
```r
# In your script, modify the distance threshold:
al_mat <- subset(unmatched, dist < 0.1)  # 90% similarity
```

#### Change Matching Algorithm
```r
# Available methods: "jw", "lv", "dl", "hamming", "lcs", "qgram", "cosine"
mm <- stringdist_join(dataset1, dataset2, 
                     method = "jw",  # Jaro-Winkler
                     max_dist = 99)
```

## 💡 Example Workflow

```r
# Load libraries
library(readxl)
library(dplyr)
library(fuzzyjoin)
library(stringdist)

# Read data
sanctions <- read_excel("CSI700_saction_mapping.xlsx")
csi700 <- read_excel("CSI700_saction_mapping.xlsx", sheet = "CSI700")

# Prepare data for matching
sanctions <- sanctions %>% rename(company = Entity_EN)
csi700 <- csi700 %>% rename(company = entity_name_en)

# Perform fuzzy matching
matches <- stringdist_join(csi700, sanctions,
                          by = "company", 
                          mode = 'left', 
                          method = "jw",
                          max_dist = 99, 
                          distance_col = 'dist') %>%
          group_by(company.x) %>%
          slice_min(order_by = dist, n = 1)

# Filter high-confidence matches
high_confidence <- subset(matches, dist < 0.1)

# Export results
write_xlsx(high_confidence, "matched_companies.xlsx")
```

## 📊 Input Data Format

Your Excel file should contain:

### Sheet 1: Sanctions List
| Entity_EN | Country | Sanction_Type |
|-----------|---------|---------------|
| Company A | China   | Economic      |
| Company B | China   | Financial     |

### Sheet 2: CSI700 Companies
| entity_name_en | entity_name_cn | Ticker |
|----------------|----------------|--------|
| Company Alpha  | 公司甲          | 000001 |
| Company Beta   | 公司乙          | 000002 |

## 🎯 Output Format

Results include:
- **company.x**: Original company name from first dataset
- **company.y**: Matched company name from second dataset  
- **dist**: Similarity score (0 = perfect match, 1 = no similarity)
- **Additional fields**: Preserved from original datasets

## ⚙️ Configuration

### Matching Sensitivity
- **Exact matches**: `dist == 0.0`
- **High confidence**: `dist < 0.1` (90%+ similarity)
- **Medium confidence**: `dist < 0.3` (70%+ similarity)
- **Low confidence**: `dist < 0.5` (50%+ similarity)

### Performance Tuning
- **Large datasets**: Use `max_dist` parameter to limit search space
- **Memory optimization**: Process in chunks for very large files
- **Speed optimization**: Use simpler distance methods for initial screening

## 🔍 Use Cases

### Compliance Screening
```r
# Find CSI700 companies that may be on sanctions lists
sanctions_matches <- fuzzy_match(csi700_companies, sanctions_list)
flagged_companies <- filter(sanctions_matches, dist < 0.1)
```

### Data Integration
```r
# Match company names across different data vendors
vendor_matches <- fuzzy_match(vendor_a_data, vendor_b_data)
consolidated_data <- merge_matched_data(vendor_matches)
```

### Quality Assurance
```r
# Find potential duplicates in company database
duplicates <- fuzzy_match(company_db, company_db)
review_list <- filter(duplicates, dist < 0.2 & dist > 0)
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **fuzzyjoin** package for R-based fuzzy matching
- **stringdist** package for distance calculations
- **reticulate** for Python integration
- **difflib** and **polyfuzz** for advanced Python matching algorithms

## 📞 Support

For questions or issues:
1. Check existing [Issues](../../issues)
2. Create a new issue with detailed description
3. Include sample data (anonymized) if possible

---

**Note**: This tool is designed for legitimate compliance and data integration purposes. Always ensure you have proper authorization to process and match company data according to your organization's policies and applicable regulations. # CFinancialEntityMatcher
