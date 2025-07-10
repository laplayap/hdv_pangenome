library("Biostrings")
library("pheatmap")
library("RColorBrewer")

hdv_refseqs <- readDNAStringSet('hdv_refseq_set_typeId.fa', format = "fasta")

n <- length(hdv_refseqs)
pid_matrix <- matrix(data = NA, nrow = n, ncol = n)
rownames(pid_matrix) <- colnames(pid_matrix) <- names(hdv_refseqs)

for (i in 1:n) {
  for (j in i:n) {
    aln <- pairwiseAlignment(hdv_refseqs[[i]], hdv_refseqs[[j]], type = "global")
    pid_val <- pid(aln, type = "PID1")
    pid_matrix[i, j] <- pid_val
    pid_matrix[j, i] <- pid_val
  }
}

# representation heatmap

breaks <- c(0, 70, 75, 80, 85, 90, 95, 100)

colors <- brewer.pal(7, "Blues")

pheatmap(pid_matrix,
         main = "% d'identité (alignement global)",
         display_numbers = TRUE,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         color = colors)

write.csv(pid_matrix, "pid_matrix.csv")


# exploration des valeurs
pid_vals <- pid_matrix[upper.tri(pid_matrix)]
summary(pid_vals)
hist(pid_vals,
     main = "Distribution du % d'identité par paires de séquences\n(total = 231 paires)",
     xlab = " % identité",
     ylab = "nb de paires",
     col = "steelblue",
     breaks = 20)
length(pid_vals)

######################################################################
### visualization avancée ###
# Get the indices of the minimum value in the upper triangle (excluding diagonal)
min_idx <- which(pid_matrix == min(pid_matrix[upper.tri(pid_matrix)]), arr.ind = TRUE)

# Extract the corresponding sequence names
seq1 <- rownames(pid_matrix)[min_idx[1]]
seq2 <- colnames(pid_matrix)[min_idx[2]]

# Show the result
cat("Lowest % identity is between:", seq1, "and", seq2, "\n")
cat("Value:", pid_matrix[min_idx], "%\n")

aln <- pairwiseAlignment(hdv_refseqs[[seq1]], hdv_refseqs[[seq2]], type = "global")

# Extract aligned sequences as character vectors
pattern <- as.character(alignedPattern(aln))
subject <- as.character(alignedSubject(aln))

# Convert to vectors of individual characters
pat_vec <- strsplit(pattern, "")[[1]]
sub_vec <- strsplit(subject, "")[[1]]

# Define window size
window_size <- 50

# Total alignment length
alignment_length <- length(pat_vec)

# Store identity values
identity_values <- numeric()

# Slide the window
for (i in 1:(alignment_length - window_size + 1)) {
  pat_window <- pat_vec[i:(i + window_size - 1)]
  sub_window <- sub_vec[i:(i + window_size - 1)]
  
  # Count matches (ignore gaps if you prefer)
  matches <- sum(pat_window == sub_window & pat_window != "-" & sub_window != "-")
  valid_positions <- sum(pat_window != "-" & sub_window != "-")
  
  # Percent identity in this window
  identity <- ifelse(valid_positions > 0, matches / valid_positions * 100, NA)
  identity_values <- c(identity_values, identity)
}


# Position for plotting
positions <- 1:length(identity_values)

# Plot
plot(positions, identity_values,
     type = "l",
     col = "steelblue",
     lwd = 2,
     ylim = c(0, 100),
     xlab = "Alignment position (start of window)",
     ylab = "% Identity",
     main = "Sliding Window Identity")
abline(h = 70, col = "red", lty = 2)  # example threshold

#########################################################
# Quelles séquences dans chaque bin de l'histogramme ?

#install.packages("igraph")
library(igraph)
# Set threshold (in %)
threshold <- 90

# Build adjacency matrix: TRUE if identity ≥ threshold
adj_matrix <- pid_matrix >= threshold

# Remove self-comparisons (optional)
diag(adj_matrix) <- FALSE

# Build graph from adjacency matrix
g <- graph_from_adjacency_matrix(adj_matrix, mode = "undirected", diag = FALSE)

# Find connected components (groups)
components <- components(g)

# Group assignment for each sequence
group_assignments <- components$membership

# See how many groups
table(group_assignments)

# View group members
split(names(group_assignments), group_assignments)

######################################################################
