from typing import Union


class Matrix:
    def __init__(self, matrix: list[list[int]]):
        """
        Initialize the matrix.
        :param matrix: 2D list of integers
        """
        self._matrix = matrix
        self._rows = len(matrix)
        self._columns = len(matrix[0])

    def __getitem__(self, item: int) -> list[int]:
        """
        Get a row of the matrix.
        :param item: index of the row
        :return: list[int]: row of the matrix
        """
        return self._matrix[item]

    def norm(self) -> float:
        """
        :return: Euclidean norm of the matrix
        """
        return sum([element ** 2 for row in self._matrix for element in row]) ** 0.5

    def _arithmetical_operation(self, other: 'Matrix', operation: callable) -> 'Matrix':
        """
            Apply an operation (addition or subtraction) between two matrices.
            :param other: Matrix object
            :param operation: A callable representing the operation to apply
            :return: Matrix: result of the operation
            """
        if self._rows != other.rows or self._columns != other.columns:
            raise ValueError("Matrices must have the same dimensions")

        return Matrix([[operation(self._matrix[i][j], other.matrix[i][j])
                        for j in range(self._columns)] for i in range(self._rows)])

    def __add__(self, other: 'Matrix') -> 'Matrix':
        """
        Add another matrix to this matrix.
        :param other: Matrix object
        :return: Matrix: sum of two matrices
        """
        return self._arithmetical_operation(other, lambda x, y: x + y)

    def __sub__(self, other: 'Matrix') -> 'Matrix':
        """
        Subtract another matrix from this matrix.
        :param other: Matrix object
        :return: Matrix: difference of two matrices
        """
        return self._arithmetical_operation(other, lambda x, y: x - y)

    def __mul__(self, other: Union['Matrix', int]) -> 'Matrix':
        """
        Multiply this matrix by another matrix or a scalar.
        :param other: Matrix object or integer scalar
        :return: Matrix: product of two matrices or scalar multiplication
        """
        if isinstance(other, int):
            return Matrix([[element * other for element in row] for row in self._matrix])

        if isinstance(other, Matrix):
            if self._columns != other.rows:
                raise ValueError("Number of columns of the first matrix must be equal to the number of rows of the second matrix")

            result = Matrix.create_matrix(self._rows, other.columns)
            for i in range(self._rows):
                for j in range(other.columns):
                    for k in range(self._columns):
                        result.matrix[i][j] += self._matrix[i][k] * other.matrix[k][j]
            return result

        raise ValueError("Invalid type for multiplication")


    @property
    def rows(self) -> int:
        return self._rows

    @property
    def columns(self) -> int:
        return self._columns

    @property
    def matrix(self) -> list[list[int]]:
        return self._matrix

    @staticmethod
    def create_matrix(rows: int, columns: int, value: int = 0) -> 'Matrix':
        """
        Create a matrix with the specified dimensions and fill it with the specified value.
        :param rows: number of rows
        :param columns: number of columns
        :param value: value to fill the matrix with
        :return: Matrix: matrix with the specified dimensions and filled with the specified value
        """
        return Matrix([[value for _ in range(columns)] for _ in range(rows)])

    @staticmethod
    def from_list(vector: list) -> 'Matrix':
        """
        Create a matrix from a list of lists.
        :param vector: 2D list of integers
        :return: Matrix: matrix created from the list
        """
        return Matrix([[element] for element in vector])
