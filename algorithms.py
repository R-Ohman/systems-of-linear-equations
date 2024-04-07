from typing import Callable
from matrix import Matrix


def solve_jacobi(a: 'Matrix', b: 'Matrix', residuum: float = 1e-6) -> (int, list[float]):
    """
    Solve the system of linear equations Ax = b using the Jacobi method.
    :param a: system matrix
    :param b: right side of the equation
    :param residuum: value to stop the iterations
    :return: number of iterations, residual vector
    """
    return solve_linear_system(a, b, jacobi_method_iteration, residuum)


def solve_gauss_seidel(a: 'Matrix', b: 'Matrix', residuum: float = 1e-6) -> (int, list[float]):
    """
    Solve the system of linear equations Ax = b using the Gauss-Seidel method.
    :param a: system matrix
    :param b: right side of the equation
    :param residuum: value to stop the iterations
    :return: number of iterations, residual vector
    """
    return solve_linear_system(a, b, gauss_seidel_method_iteration, residuum)


def solve_linear_system(a: 'Matrix', b: 'Matrix', method: Callable[['Matrix', 'Matrix', 'Matrix', int], float], residuum: float = 1e-6) -> (int, list[float]):
    """
    Solve the system of linear equations Ax = b using the specified method.
    :param a: system matrix
    :param b: right side of the equation
    :param method: method to use for solving the system (e.g., jacobi_method, gauss_seidel_method)
    :param residuum: value to stop the iterations
    :return: number of iterations, residual vector
    """
    x = Matrix.create_matrix(a.rows, 1)
    err = [float('inf')]
    iterations = 0
    while err[-1] > residuum:
        iterations += 1
        x_new = Matrix.create_matrix(a.rows, 1)
        for i in range(a.rows):
            x_new[i][0] = method(a, b, x, i)

        err.append((a * x_new - b).norm())
        x = x_new
    return iterations, err[1:]


def jacobi_method_iteration(a: 'Matrix', b: 'Matrix', x: 'Matrix', i: int) -> float:
    """
    Perform one iteration of the Jacobi method.
    :param a: system matrix
    :param b: right side of the equation
    :param x: current solution vector
    :param i: index of the equation to solve
    :return: updated value of x[i][0]
    """
    s = sum(a[i][j] * x[j][0] for j in range(a.rows) if i != j)
    return (b[i][0] - s) / a[i][i]


def gauss_seidel_method_iteration(a: 'Matrix', b: 'Matrix', x: 'Matrix', i: int) -> float:
    """
    Perform one iteration of the Gauss-Seidel method.
    :param a: system matrix
    :param b: right side of the equation
    :param x: current solution vector
    :param i: index of the equation to solve
    :return: updated value of x[i][0]
    """
    s1 = sum(a[i][j] * x[j][0] for j in range(i))
    s2 = sum(a[i][j] * x[j][0] for j in range(i + 1, a.rows))
    return (b[i][0] - s1 - s2) / a[i][i]
