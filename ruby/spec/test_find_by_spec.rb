require_relative 'spec_models/find_by/Student.rb'

describe 'test_find_by' do

  def comparar_students(student1, student2)
    expect(student1.id).to eq(student2.id)
    expect(student1.full_name).to eq(student2.full_name)
    expect(student1.grade).to eq(student2.grade)
  end

  let(:full_name) { 'Bob Esponja' }
  let(:un_student) do
    un_student = Student.new
    un_student.full_name = full_name
    un_student.grade = 9
    un_student
  end
  let(:otro_student) do
    otro_student = Student.new
    otro_student.full_name = "Gari Esponja"
    otro_student.grade = 2
    otro_student
  end


  context 'find_by_<what>' do
    before do
      un_student.save!
      otro_student.save!
    end

    it 'find_by_id entre dos elementos' do
      encontrado = Student.find_by_id(un_student.id).first
      comparar_students(encontrado, un_student)
    end

    it 'find_by_promoted' do
      aprobado = Student.find_by_promoted(true).first
      comparar_students(aprobado, un_student)
    end

    it 'find_by_last_name' do
      esponjas = Student.find_by_has_last_name(true,'Esponja')
      comparar_students(esponjas.first, un_student)
      comparar_students(esponjas.last, otro_student)
    end

    #TODO Añadir tests find_by con composición y herencia
    #TODO Los mensajes find_by, al ser enviados a una superclase o mixin, traen también todas las instancias de sus descendientes.
  end
end