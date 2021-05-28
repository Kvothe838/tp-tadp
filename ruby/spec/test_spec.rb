# frozen_string_literal: true

describe 'ORM' do
  def comparar_persona(persona, persona2)
    expect(persona.id).to eq(persona2.id)
    expect(persona.last_name).to eq(persona2.last_name)
    expect(persona.first_name).to eq(persona2.first_name)
    expect(persona.age).to eq(persona2.age)
  end

  let(:first_name) { 'Kal' }
  let(:last_name) { 'El'  }
  let(:age) { 30 }

  let(:persona) do
    persona = Person.new
    persona.first_name = first_name
    persona.last_name = last_name
    persona.age = age
    persona
  end

  before do
    TADB::DB.clear_all

    #En vez de hacer un include en la clase Person la puedo hacer de esta forma.
    Person.include(Persistible)
    Person.include(SpecHelperMethods)
  end

  after do
    TADB::DB.clear_all
  end

  context 'crea correctamente una persona como admin' do
    before do
      persona.is_admin = true
      persona.save!
    end

    it 'posee un id presente' do
      expect(persona.id).not_to be_nil
    end

    it 'Existe el registro en la tabla' do
      hay_fila_con_datos_persona = TADB::DB.table(persona.class.to_s).entries.any? { |fila|
        fila[:first_name] == 'Kal' && fila[:last_name] == 'El' && fila[:age] == 30 && fila[:is_admin] }

      expect(hay_fila_con_datos_persona).to be_truthy
    end
  end

  context 'Testeando refresh!' do
    let(:first_name) { 'Kramer' }
    let(:last_name) { 'Kramer'  }
    let(:age) { 40 }
    let(:new_first_name) { 'Fulanito' }
    let(:new_last_name) { 'Cosme'  }
    let(:new_age) { 40 }


    subject(:refresh!) { persona.refresh! }

    before do
      persona.save!
    end

    context 'cambiando solo el last_name' do
      it 'devuelve el nuevo last_name' do
        persona.last_name= new_last_name
        expect(persona.last_name).to eq(new_last_name)
        refresh!
        expect(persona.last_name).to eq(last_name)
      end
    end

    context 'cambiando solo el first_name' do
      it 'devuelve el nuevo first_name' do
        persona.first_name= new_first_name
        expect(persona.first_name).to eq(new_first_name)
        refresh!
        expect(persona.first_name).to eq(first_name)
      end
    end

    context 'cambiando solo el age' do
      it 'devuelve el nuevo age' do
        persona.age= new_age
        expect(persona.age).to eq(new_age)
        refresh!
        expect(persona.age).to eq(age)
      end
    end
  end

  context '#forget' do
    let(:first_name) { 'Homero' }
    let(:last_name) { 'Simpson'  }
    let(:age) { 2021 - 1956 }

    before do
      persona.save!
    end

    subject(:forget) { persona.forget! }

    it 'posee su id si aun no se hizo el forget' do
      expect(persona.id).not_to be_nil
    end

    it 'pierde su id si se llama al forget' do
      forget
      expect(persona.id).to be_nil
    end

    it 'no se encuentra la entrada de Homero simpson despues del forget' do
      forget
      expresion = TADB::DB.table(persona.class.to_s).entries.any? do |fila|
        fila[:last_name] == 'Simpson' && fila[:first_name] == 'Homero'
      end
      expect(expresion).to be_falsey
    end
  end

  context '#all_instances' do
    let(:expected_db_attrbiutes) { persona.instance_variables }
    let(:first_name) { 'John' }
    let(:last_name) { 'Smith'  }
    let(:age) { 69 }
    let!(:john_wayne) do
      otra_persona = Person.new
      otra_persona.last_name = 'Wayne'
      otra_persona.first_name = 'John'
      otra_persona.age = 96
      otra_persona.save!
      otra_persona
    end

    before do
      persona.save!
    end

    subject(:all_instances) { Person.all_instances! }

    it 'contiene todos los atributos' do
      expect(all_instances.last.instance_variables).to eq(expected_db_attrbiutes)
    end

    it 'Contiene a John Wayne' do
      expect(all_instances.first.id).to eq(john_wayne.id)
      expect(all_instances.first.last_name).to eq(john_wayne.last_name)
      expect(all_instances.first.first_name).to eq(john_wayne.first_name)
      expect(all_instances.first.age).to eq(john_wayne.age)
    end

    it 'Contiene a John Smith' do
      comparar_persona(all_instances.last, persona)
    end
  end

  context '#find_by_x' do
    let(:first_name) { 'Esponja' }
    let(:last_name) { 'Bob'  }
    let(:age) { 20 }

    before do
      persona.save!
    end

    context 'find_by_id' do
      let(:id) { persona.id }

      subject {Person.find_by_id(id).first }

      it 'find by id trae a Bob Esponja' do
        comparar_persona(subject, persona)
      end
    end

    context 'find_by_last_name' do
      subject {Person.find_by_last_name(persona.last_name).first }

      it 'find by last name trae a Bob Esponja' do
        comparar_persona(subject, persona)
      end
    end

    context 'find_by_last_name' do
      subject {Person.find_by_first_name(persona.first_name).first }

      it 'find by first name trae a Bob Esponja' do
        comparar_persona(subject, persona)
      end
    end

    context 'find_by_age' do
      subject {Person.find_by_age(persona.age).first }

      it 'find by age trae a Bob Esponja' do
        comparar_persona(subject, persona)
      end
    end
  end

  context 'Errores en la creacion de Person' do
    let(:first_name) { 'Esponja' }
    let(:last_name) { 'Bob' }
    let(:age) { 20 }

    subject(:validar) { persona.send(:validar!) }

    context 'Cuando no hay errores' do
      it 'crea a Bob Esponja sin errores' do
        persona.save!
        expect(validar).to be_nil
      end
    end

    context 'cuando hay errores' do
      context 'cuando el first_name es de un tipo incorrecto' do
        let(:first_name) { 30 }
        let(:mensaje_esperado) { 'El atributo first_name no contiene valor de clase String' }

        it 'falla la validacion a Bob Esponja' do
          expect { persona.save! }.to raise_error(TipoIncorrectoException, mensaje_esperado)
        end
      end

      context 'cuando el is_admin es de un tipo incorrecto' do
        let(:is_admin) { 'no' }
        let(:mensaje_esperado) { 'El atributo is_admin no contiene valor de clase Boolean' }

        it 'falla la validacion a Bob Esponja' do
          persona.is_admin = is_admin
          expect { persona.save! }.to raise_error(TipoIncorrectoException, mensaje_esperado)
        end
      end
    end
  end

  context 'Errores en la creacion de PersonWithGrades' do
    context 'cuando el grades es un array con tipos correctos' do
      let(:grades){
        one_grade = Grade.new
        one_grade.value = 10
        another_grade = Grade.new
        another_grade.value = 7
        [one_grade, another_grade]
      }
      let(:age) { 20 }
      it 'pasa la validacion Juan Gómez' do
        persona_con_grades = PersonWithGrades.new
        persona_con_grades.full_name = 'Juan Gómez'
        persona_con_grades.age= 20
        persona_con_grades.grades = grades
        persona_con_grades.save!
        expect(persona_con_grades.send(:validar!)).to be_nil
      end
    end

    context 'cuando el grades es un array con tipos incorrectos' do
      it 'no pasa la validación con dos Student en grades' do
        persona_con_grades = PersonWithGrades.new
        persona_con_grades.full_name = 'Juan Gómez'
        persona_con_grades.age= 20
        one_student = Student.new
        one_student.full_name = "Juan Gomez"
        one_student.age= 20
        other_student = Student.new
        other_student.full_name = "sarasa"
        other_student.age = 21
        persona_con_grades.grades = [one_student, other_student]
        mensaje_esperado = "El atributo grades contiene al menos un elemento que no es de clase Grade"
        expect { persona_con_grades.save! }.to raise_error(TipoIncorrectoException, mensaje_esperado)
      end

      it 'no pasa la validación con un Grade y un Student en grades' do
        persona_con_grades = PersonWithGrades.new
        persona_con_grades.full_name = 'Juan Gómez'
        persona_con_grades.age = 20
        one_student = Student.new
        one_student.full_name = "Juan Gomez"
        one_student.age = 20
        one_grade = Grade.new
        one_grade.value = "sarasa"
        persona_con_grades.grades = [one_grade, one_student]
        mensaje_esperado = "El atributo value no contiene valor de clase Numeric"
        expect { persona_con_grades.save! }.to raise_error(TipoIncorrectoException, mensaje_esperado)
      end

      it 'no pasa la validación con un Student y un Grade en grades' do
        persona_con_grades = PersonWithGrades.new
        persona_con_grades.full_name = 'Juan Gómez'
        persona_con_grades.age = 20
        one_student = Student.new
        one_student.full_name = "Juan Gomez"
        one_student.age = 20
        one_grade = Grade.new
        one_grade.value = "sarasa"
        persona_con_grades.grades = [one_student, one_grade]
        mensaje_esperado = "El atributo grades contiene al menos un elemento que no es de clase Grade"
        expect { persona_con_grades.save! }.to raise_error(TipoIncorrectoException, mensaje_esperado)
      end

      it 'no pasa la validación con un PersonWithStudents' do
        persona_con_students = PersonWithStudents.new
        persona_con_students.full_name = 'Juan Gómez'
        persona_con_students.age = 20
        one_student = Student.new
        one_student.full_name = "Juan Gomez"
        one_student.age = 20
        one_grade = Grade.new
        one_grade.value = "sarasa"
        one_student.grade = one_grade
        persona_con_students.students = [one_student]
        mensaje_esperado = "El atributo value no contiene valor de clase Numeric"
        expect { persona_con_students.save! }.to raise_error(TipoIncorrectoException, mensaje_esperado)
      end
    end
  end


  context 'Errores en la creacion de Persona con Contenido invalido' do
    let(:first_name) { 'Esponja' }
    let(:last_name) { 'Bob'  }
    let(:age) { 20 }

    subject(:validar) { persona.send(:validar!) }

    context 'Cuando no hay errores' do
      it 'crea a Bob Esponja sin errores' do
        one_grade = Grade.new
        one_grade.value = 15
        persona.grade = one_grade
        persona.save!
        expect(validar).to be_nil
      end
    end

    context 'cuando hay errores' do
      context 'cuando el first_name es de un contenido incorrecto' do
        let(:first_name) { "" }
        let(:mensaje_esperado) { 'El atributo first_name no contiene valor en los limites esperados' }

        it 'falla la validacion a Bob Esponja' do
          expect { persona.save! }.to raise_error(TipoIncorrectoException, mensaje_esperado)
        end
      end

      context 'cuando la edad es  inferior al minimo' do
        let(:age) { 10 }
        let(:mensaje_esperado) { 'El atributo age no contiene valor en los limites esperados' }

        it 'falla la validacion a Bob Esponja' do

          expect { persona.save! }.to raise_error(TipoIncorrectoException, mensaje_esperado)
        end
      end
      context 'cuando la edad es  superior al minimo' do
        let(:age) { 110 }
        let(:mensaje_esperado) { 'El atributo age no contiene valor en los limites esperados' }

        it 'falla la validacion a Bob Esponja' do

          expect { persona.save! }.to raise_error(TipoIncorrectoException, mensaje_esperado)
        end
      end
    end
  end




end




