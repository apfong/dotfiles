import React, { Component, PropTypes } from 'react'
'heyo5'

export default class Name extends Component {
  printTired () {
    return this.props.is_tired ? 'You are tired' : 'You are not tired...'
  }
  render () {
    const style = {
      color: 'white',
      backgroundColor: 'grey',
      padding: '50px'
    }
    const shared_style = {
      margin: '15px',
      color: '#9f9'
    }
    let nums = []
    for (var i = 1; i < this.props.number + 1; i++) {
      nums.push(i)
    }

    let warning = null
    if (this.props.show_warning) {
      const warning_style = {
        padding: '10px',
        color: '#f99'
      }
      warning = <div style={warning_style}>WARNING! Content here might or might not be true...</div>
    }
    let pet_or_pets = 'pets'
    if (this.props.pets.length === 1) {
      pet_or_pets = 'pet'
    }
    return <div style={style}>
      {warning}
      <div style={shared_style}>
        Hello, {this.props.name}
      </div>
      <div style={shared_style}>
        You are {this.props.age} years old.
      </div>
      <div style={shared_style}>
        You have {this.props.pets.length} {pet_or_pets}...
        {this.props.pets.map((pet) => {
          return <div>One is {pet}</div>
        })}
      </div>
      <div style={shared_style}>
        { this.printTired.bind(this)() }
      </div>
      {(function () {
        return nums.map((i) => {
          return <div>{i}</div>
        })
      })()}
    </div>
  }
}
Name.propTypes = {
  name: PropTypes.string,
  number: PropTypes.number,
  pets: PropTypes.array,
  age: PropTypes.number,
  is_tired: PropTypes.bool,
  show_warning: PropTypes.bool
}
Name.defaultProps = {
  name: 'Victor',
  number: 5,
  pets: ['Gaia'],
  age: 18,
  is_tired: false,
  show_warning: false
}
