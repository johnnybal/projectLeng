#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const chalk = require('chalk');

console.log(chalk.blue('🔍 Checking project dependencies...'));

// Read package.json
const packageJson = JSON.parse(fs.readFileSync(path.join(process.cwd(), 'package.json'), 'utf8'));

// List of forbidden dependencies
const forbiddenDependencies = [
    'mongodb',
    'mongoose',
    'monk',
    'mongojs',
    'mongodb-core'
];

// Check both dependencies and devDependencies
const allDependencies = {
    ...packageJson.dependencies,
    ...packageJson.devDependencies
};

let foundForbiddenDeps = false;

// Check for forbidden dependencies
forbiddenDependencies.forEach(dep => {
    if (allDependencies[dep]) {
        console.log(chalk.red(`❌ Found forbidden dependency: ${dep}`));
        foundForbiddenDeps = true;
    }
});

// Search for MongoDB imports in source files
function searchForMongoImports(dir) {
    const files = fs.readdirSync(dir);
    
    files.forEach(file => {
        const filePath = path.join(dir, file);
        const stat = fs.statSync(filePath);
        
        if (stat.isDirectory() && !file.includes('node_modules')) {
            searchForMongoImports(filePath);
        } else if (file.endsWith('.js')) {
            const content = fs.readFileSync(filePath, 'utf8');
            if (content.includes('mongoose') || 
                content.includes('mongodb') || 
                content.includes('mongo.connect')) {
                console.log(chalk.red(`❌ Found MongoDB reference in: ${filePath}`));
                foundForbiddenDeps = true;
            }
        }
    });
}

// Check source files
console.log(chalk.blue('🔍 Checking source files for MongoDB references...'));
searchForMongoImports(path.join(process.cwd(), 'src'));

// Print final message
if (foundForbiddenDeps) {
    console.log(chalk.red('\n❌ Project contains MongoDB dependencies or references'));
    console.log(chalk.yellow('\nThis is a Firebase-only project. Please remove all MongoDB dependencies and references.'));
    console.log(chalk.yellow('Suggested actions:'));
    console.log(chalk.yellow('1. Remove MongoDB packages from package.json'));
    console.log(chalk.yellow('2. Remove MongoDB imports from source files'));
    console.log(chalk.yellow('3. Use Firebase Firestore for database operations'));
    process.exit(1);
} else {
    console.log(chalk.green('\n✅ No MongoDB dependencies or references found'));
    console.log(chalk.blue('\nThis is a Firebase-only project using:'));
    console.log(chalk.blue('- Firebase Authentication'));
    console.log(chalk.blue('- Cloud Firestore'));
    console.log(chalk.blue('- Firebase Cloud Functions'));
    console.log(chalk.blue('- Firebase Storage'));
} 