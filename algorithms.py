from typing import Callable
from matrix import Matrix


def solve_factorization_lu(a: 'Matrix', b: 'Matrix') -> ('Matrix', float):
    """
    Solve the system of linear equations Ax = b using the LU factorization method.
    :param a: system matrix
    :param b: right side of the equation
    :return: solution vector, residual error
    """
    n = a.rows
    l = Matrix.create_matrix(n, n)
    u = Matrix.create_matrix(n, n)

    for i in range(n):
        for j in range(i, n):
            u[i][j] = a[i][j] - sum(l[i][k] * u[k][j] for k in range(i))
        for j in range(i + 1, n):
            l[j][i] = (a[j][i] - sum(l[j][k] * u[k][i] for k in range(i))) / u[i][i]

    y = Matrix.create_matrix(n, 1)
    for i in range(n):
        y[i][0] = b[i][0] - sum(l[i][j] * y[j][0] for j in range(i))

    x = Matrix.create_matrix(n, 1)
    for i in range(n - 1, -1, -1):
        x[i][0] = (y[i][0] - sum(u[i][j] * x[j][0] for j in range(i + 1, n))) / u[i][i]

    residuum = (a * x - b).norm()
    return x, residuum


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


def solve_linear_system(a: 'Matrix', b: 'Matrix', method: Callable[[list['Matrix'], int], float],
                        residuum: float = 1e-6) -> (int, list[float]):
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
            x_new[i][0] = method([a, b, x, x_new], i)

        new_err = (a * x_new - b).norm()
        err.append(new_err)
        x = x_new

        if new_err > 1/residuum:
            break

    return iterations, err[1:]


def jacobi_method_iteration(matrices: list['Matrix'], i: int) -> float:
    """
    Perform one iteration of the Jacobi method.
    :param matrices: list of matrices [a, b, x, _]
            a: system matrix,
            b: right side of the equation,
            x: current solution vector
    :param i: index of the equation to solve
    :return: updated value of x[i][0]
    """
    a, b, x, _ = matrices

    s = sum(a[i][j] * x[j][0] for j in range(a.rows) if i != j)
    return (b[i][0] - s) / a[i][i]


def gauss_seidel_method_iteration(matrices: list['Matrix'], i: int) -> float:
    """
    Perform one iteration of the Gauss-Seidel method.
    :param matrices: list of matrices [a, b, x, x_new]
            a: system matrix,
            b: right side of the equation,
            x: current solution vector,
            x_new: new solution vector
    :param i: index of the equation to solve
    :return: updated value of x[i][0]
    """
    a, b, x, x_new = matrices
    s1 = sum(a[i][j] * x_new[j][0] for j in range(i))
    s2 = sum(a[i][j] * x[j][0] for j in range(i + 1, a.rows))
    return (b[i][0] - s1 - s2) / a[i][i]
