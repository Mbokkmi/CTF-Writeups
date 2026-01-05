#!/bin/bash

BASE="CTF-Writeups"

echo "[+] Creation de la structure principale..."
mkdir -p $BASE/{Beginner_picoMini_2022,picoCTF_2019,picoCTF_2020,picoCTF_2021,picoCTF_2022,picoCTF_2023,picoCTF_2024,picoCTF_2025,picoGym_Exclusive,picoMini_by_redpwn}

CATEGORIES="Binary_Exploitation Cryptography Forensics General_Skills Reverse_Engineering Web_Exploitation"

for year in 2019 2020 2021 2022 2023 2024 2025; do
    YEAR_DIR="$BASE/picoCTF_$year"
    echo "[+] Creation de $YEAR_DIR"

    mkdir -p $YEAR_DIR

    # README de l'annee
    cat > $YEAR_DIR/README.md << EOF
# picoCTF $year

Writeups pour picoCTF $year.
EOF

    for cat in $CATEGORIES; do
        mkdir -p $YEAR_DIR/$cat

        # README de la categorie
        cat > $YEAR_DIR/$cat/README.md << EOF
# $cat - picoCTF $year

Liste des challenges et writeups.
EOF
    done
done

# Beginner
BEGINNER="$BASE/Beginner_picoMini_2022"
mkdir -p $BEGINNER
cat > $BEGINNER/README.md << EOF
# Beginner picoMini 2022
EOF

for cat in $CATEGORIES; do
    mkdir -p $BEGINNER/$cat
    cat > $BEGINNER/$cat/README.md << EOF
# $cat - Beginner picoMini 2022
EOF
done

# README principal
cat > $BASE/README.md << EOF
# CTF Writeups Collection

Base de connaissances personnelle en cybersécurité offensive.
EOF

echo "[✓] Structure Cajac-style cree avec succes."

