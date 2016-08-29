var Exercise = React.createClass({
  render: function() {
    var setNodes = this.props.exercise.sets.map(function(set) {
      var model = new Stronglifters.Set(set);
      return (
        <Set key={set.id} model={model} />
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
