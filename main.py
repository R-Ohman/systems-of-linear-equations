from math import sin
import matplotlib.pyplot as plt
from algorithms import *
from datetime import datetime


def create_system_matrix(a1, a2, a3, size):
    matrix = [[0 for i in range(size)] for j in range(size)]
    for i in range(size):
        matrix[i][i] = a1
        if i < size - 1:
            matrix[i + 1][i] = a2
            matrix[i][i + 1] = a2
        if i < size - 2:
            matrix[i + 2][i] = a3
            matrix[i][i + 2] = a3

    return matrix


def plot(x, y, title, x_label, y_label, log=True):
    plt.plot(x, y)
    plt.title(title)
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.yscale('log' if log else 'linear')
    plt.show()


def analyze_iteration_methods():
    N = 934
    sm = create_system_matrix(a1=11,  a2=-1, a3=-1, size=N)
    b = [sin(n*7) for n in range(N)]

    time = datetime.now()
    iter, err = solve_jacobi(a=Matrix(sm), b=Matrix.from_list(b), residuum=1e-9)
    print("Jacobi method: ", (datetime.now() - time).total_seconds(), "s")
    plot(range(iter), err, "Jacobi method", "Iterations", "Residual error")

    time = datetime.now()
    iter, err = solve_gauss_seidel(a=Matrix(sm), b=Matrix.from_list(b), residuum=1e-9)
    print("Gauss-Seidel method: ", (datetime.now() - time).total_seconds(), "s")
    plot(range(iter), err, "Gauss-Seidel method", "Iterations", "Residual error")


def analyze_convergence():
    N = 934
    sm = create_system_matrix(a1=3, a2=-1, a3=-1, size=N)
    b = [sin(n * 7) for n in range(N)]

    iter, err = solve_jacobi(a=Matrix(sm), b=Matrix.from_list(b), residuum=1e-9)
    plot(range(iter), err, "Jacobi method", "Iterations", "Residual error")

    iter, err = solve_gauss_seidel(a=Matrix(sm), b=Matrix.from_list(b), residuum=1e-9)
    plot(range(iter), err, "Gauss-Seidel method", "Iterations", "Residual error")


def analyze_factorization():
    N = 934
    sm = create_system_matrix(a1=3, a2=-1, a3=-1, size=N)
    b = [sin(n * 7) for n in range(N)]

    time = datetime.now()
    solution_vector, err = solve_factorization_lu(a=Matrix(sm), b=Matrix.from_list(b))
    print("Factorization LU method: ", (datetime.now() - time).total_seconds(), "s")
    print("Residual error: ", err)


def main():
    # analyze_iteration_methods()
    # analyze_convergence()
    analyze_factorization()


if __name__ == '__main__':
    main()
