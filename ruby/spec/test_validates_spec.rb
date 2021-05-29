require_relative 'spec_models/validates/Grade_Validates.rb'
require_relative 'spec_models/validates/Student_Validates.rb'

describe 'test_validates' do
  let(:student) do
    student = Student_Validates.new
    student.full_name = "Juan"
    student.age = 19
    grade = Grade_Validates.new
    grade.value = 5
    student.grades = [grade]
    student
  end

  it 'crea un student sin grade' do
    student.save!

    expect(student.id).not_to be_nil
  end

  it 'crea un student con grade con formato incorrecto' do
    grade = Grade_Validates.new
    grade.value = "Test"
    student.grade = grade

    expect { student.save! }.to raise_error(TipoIncorrectoException, "El atributo value no contiene valor de clase Numeric")
  end

  it 'fallo en full_name' do
    student2 = Student_Validates.new
    student2.full_name = 1
    student2.age = 19
    grade = Grade_Validates.new
    grade.value = 5
    student2.grades = [grade]

    expect { student2.save! }.to raise_error(TipoIncorrectoException, "El atributo full_name no contiene valor de clase String")
  end

  it 'fallo con full_name en blanco' do
    student2 = Student_Validates.new
    student2.full_name = ""
    student2.age = 19
    expect { student2.save! }.to raise_error(TipoIncorrectoException, "El atributo full_name no contiene valor en los limites esperados")
  end

  it 'fallo con límites de age' do
    student2 = Student_Validates.new
    student2.full_name = "Pepe"
    student2.age = 1
    expect { student2.save! }.to raise_error(TipoIncorrectoException, "El atributo age no contiene valor en los limites esperados")
  end

  it 'fallo con el proc validate' do
    student2 = Student_Validates.new
    student2.full_name = "Pepe"
    student2.age = 19
    grade = Grade_Validates.new
    grade.value = 5
    grade2 = Grade_Validates.new
    grade2.value = 1
    student2.grades = [grade, grade2]

    expect { student2.save! }.to raise_error(TipoIncorrectoException, "El atributo grades no contiene valor en los limites esperados")
  end

  it 'valores por defecto' do
    student2 = Student_Validates.new
    student2.full_name = "Pepe"
    student2.age = 19
    student2.save!
    expect(student2.dni).to eq(11111)
  end
end