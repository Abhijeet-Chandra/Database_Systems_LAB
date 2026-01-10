Integrity Constraints: Constraints are the rules enforced on data columns on table. These are used to limit the type of data that can go into a table. This ensures the accuracy and reliability of the data in the database. Constraints could be column level or table level. Column level constraints are applied only to one column, whereas table level constraints are applied to the whole table.
Following are commonly used constraints available in SQL.  NOT NULL Constraint: Ensures that a column cannot have NULL value.
 DEFAULT Constraint: Provides a default value for a column when none is specified.
 UNIQUE Constraint: Ensures that all values in a column are different.
 PRIMARY Key: Uniquely identifies each row/record in a database table.
 FOREIGN Key: Uniquely identifies row/record in another database table.
 CHECK Constraint: The CHECK constraint ensures that all values in a column satisfy
certain conditions.
Constraints can be specified when a table is created with the CREATE TABLE statement or you can use ALTER TABLE statement to create constraints even after the table is created.
