var Set = React.createClass({
  getInitialState: function() {
    console.log(this.props.actual_repetitions);
    return { actual_repetitions: this.props.actual_repetitions };
  },
  handleClick: function() {
    console.log([this.props.set.target_repetitions, this.state.actual_repetitions]);

    if (this.state.actual_repetitions == null) {
      this.setState({ actual_repetitions: this.props.set.target_repetitions });
    } else {
      if (this.state.actual_repetitions == 0) {
        this.setState({ actual_repetitions: this.props.set.target_repetitions });
      } else {
        this.setState({ actual_repetitions: this.state.actual_repetitions - 1 });
      }
    }
  },
  render: function(){
    return (
      <tr>
        <td>{this.props.set.type}</td>
        <td><button onClick={this.handleClick} type="button" className="button">{this.state.actual_repetitions}</button></td>
        <td>{this.props.set.target_repetitions} x {this.props.set.target_weight}</td>
        <td>{this.props.set.weight_per_side}</td>
      </tr>
    );
  }
});

var Exercise = React.createClass({
  render: function() {
    var setNodes = this.props.exercise.sets.map(function(set) {
      return (
        <Set key={set.id} set={set} actual_repetitions={set.actual_repetitions} />
      );
    });
    return (
      <div>
        <p>{this.props.exercise.name}</p>
        <table>
          <tbody>
          {setNodes}
          </tbody>
        </table>
      </div>
    );
  }
});
var Exercises = React.createClass({
  render: function(){
    var exerciseNodes = this.props.exercises.map(function(exercise) {
      return (
        <Exercise key={exercise.id} exercise={exercise} />
      );
    });
    return (
      <div>
        {exerciseNodes}
      </div>
    );
  }
});

var Workout = React.createClass({
  render: function(){
    return (
      <div>
        <p>{this.props.workout.body_weight.amount}</p>
        <p>{this.props.workout.routine_name}</p>
        <Exercises exercises={this.props.workout.exercises} />
      </div>
    );
  }
});
