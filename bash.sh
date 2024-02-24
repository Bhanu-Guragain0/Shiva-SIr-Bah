#!/bin/bash

# Function to display error messages and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Function to generate asymmetric keys
generate_keys() {
    echo "Generating public/private key pair..."
    openssl genpkey -algorithm RSA -out "$PRIVATE_KEY_FILE" || error_exit "Failed to generate private key"
    openssl rsa -pubout -in "$PRIVATE_KEY_FILE" -out "$PUBLIC_KEY_FILE" || error_exit "Failed to generate public key"
    echo "Public/private key pair generated and stored in $WORKING_DIR"
}

# Function to encrypt data
encrypt_data() {
    echo "Encrypting data using public key..."
    openssl rsautl -encrypt -pubin -inkey "$PUBLIC_KEY_FILE" -in "$DATA_FILE" -out "$ENCRYPTED_DATA_FILE" || error_exit "Failed to encrypt data"
    echo "Data encrypted and stored as $ENCRYPTED_DATA_FILE"
}

# Function to decrypt data
decrypt_data() {
    echo "Decrypting data using private key..."
    openssl rsautl -decrypt -inkey "$PRIVATE_KEY_FILE" -in "$ENCRYPTED_DATA_FILE" -out "$DECRYPTED_DATA_FILE" || error_exit "Failed to decrypt data"
    echo "Data decrypted and stored as $DECRYPTED_DATA_FILE"
}

# Main function
main() {
    # Directory to store files
    WORKING_DIR="/home/bhanu/Desktop/Task3"
    PRIVATE_KEY_FILE="$WORKING_DIR/private_key.pem"
    PUBLIC_KEY_FILE="$WORKING_DIR/public_key.pem"
    DATA_FILE="$WORKING_DIR/data.txt"
    ENCRYPTED_DATA_FILE="$WORKING_DIR/encrypted_data.bin"
    DECRYPTED_DATA_FILE="$WORKING_DIR/decrypted_data.txt"

    mkdir -p "$WORKING_DIR" || error_exit "Failed to create directory: $WORKING_DIR"
    cd "$WORKING_DIR" || error_exit "Failed to change directory to $WORKING_DIR"

    # Step 1: Generate data to encrypt
    echo "Creating file with sensitive data..."
    echo "Some sensitive data" > "$DATA_FILE" || error_exit "Failed to create data file"
    echo "File with sensitive data created: $DATA_FILE"

    # Step 2: Generate asymmetric keys (public/private key pair)
    generate_keys

    # Step 3: Encrypt the data using the public key
    encrypt_data

    # Step 4: Decrypt the data using the private key
    decrypt_data

    # Step 5: Display the decrypted data
    echo "Decrypted Data:"
    cat "$DECRYPTED_DATA_FILE"

    # Step 6: Display GitHub repository URL
    echo "GitHub Repository: https://github.com/Bhanu-Guragain0/Shiva-Sir-Bash"
}

# Execute main function
main
